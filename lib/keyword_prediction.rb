# frozen_string_literal: true

require 'csv'
require 'levenshtein'

class KeywordPrediction
  extend CustomNormalizer
  DEFAULT_KEYWORD_COL = 'keyword'
  DEFAULT_PREDICTION_COL = 'prefecture_name'

  attr_accessor :path, :index, :keyword_col, :prediction_col

  def initialize(args = {})
    @path = args[:path] ? args[:path] : 'lib/name2prefecture.csv'
    @keyword_col = args[:keyword_col] ? args[:keyword_col] : DEFAULT_KEYWORD_COL
    @prediction_col = args[:prediction_col] ? args[:prediction_col] : DEFAULT_PREDICTION_COL
  end

  def load(index_array: [])
    @index = !index_array.empty? ? load_array(index_array) : load_csv
  end

  def similarity(str1, str2)
    1 - Levenshtein.normalized_distance(str1, str2)
  end

  def compare_all(str)
    list = @index.map do |row|
      row.to_hash.merge(similarity: similarity(row[@keyword_col.to_sym], str))
    end
    list.sort_by { |h| [-h[:similarity], h[:length]] }
  end

  def match(str, similarity = 0)
    # Get maximum match every prefecture
    similarities = {}
    compare_all(str).select do |row|
      if (row[:similarity] >= similarity) && (similarities[row[@prediction_col.to_sym]].nil? || row[:similarity] > similarities[row[@prediction_col.to_sym]])
        similarities[row[@prediction_col.to_sym]] = row[:similarity]
        true
      else
        false
      end
    end
  end

  def best_match(str)
    compare_all(str)[0]
  end

  def perfect_match(str)
    match(str, 1)
  end

  def predict(str, similarity = 0)
    results = match(str, similarity)
    max_similarity = results.map { |result| result[:similarity] }.max
    results.select { |result| result[:similarity] == max_similarity }.map do |result|
      { :name => str,
        @prediction_col.to_sym => result[@prediction_col.to_sym],
        :similarity => result[:similarity],
        @keyword_col.to_sym => result[@keyword_col.to_sym] }
    end
  end

  def predicts(input_path, similarity = 0.5, force = false)
    csv = CSV.read(input_path, headers: false)
    list = []
    cache = {}
    csv.each_with_index do |row, i|
      if cache[row[0].to_sym]
        list << cache[row[0].to_sym]
        Rails.logger.info "cache #{i}"
      else
        results = predict(row[0], similarity)
        line = if results.count == 1 || force
                 results[0]
               else
                 { name: row[0] }
               end
        cache[row[0].to_sym] = line
        list << line
        Rails.logger.info i
      end
    end
    output_csv(list, [:name, @keyword_col.to_sym, :similarity, @prediction_col.to_sym])
  end

  def self.output_normalized_csv(input_path, output_path)
    csv = CSV.read(input_path, headers: true, header_converters: :symbol)
    Rails.logger.info csv.headers
    CSV.open(output_path, 'w', headers: csv.headers, write_headers: true) do |line|
      Rails.logger.info line
      csv.each do |row|
        Rails.logger.info row
        line << csv.headers.map { |h| normalize_str(row[h].to_s) }
      end
    end
  end

  private

  def load_csv
    index = []
    csv = CSV.read(@path, headers: true, header_converters: :symbol)
    csv.each do |row|
      index << row.to_hash.merge(length: row[@keyword_col.to_sym].length)
    end
    index
  end

  def load_array(array)
    array
  end

  def output_csv(list, headers = [])
    CSV.open('test.csv', 'w', headers: headers, write_headers: true) do |line|
      list.each do |row|
        line << headers.map { |h| row[h] }
      end
    end
  end
end
