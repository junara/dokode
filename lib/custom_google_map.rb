# frozen_string_literal: true

require 'geocoder'
require 'httpclient'
require 'json'

module CustomGoogleMap
  GOOGLE_PLACES_API_KEY = ENV['GOOGLE_API_KEY']
  LANGUAGE = 'ja'
  SLEEP_WAIT = 0.1

  module Csv
    HEADER_ARRAY = %w[query place_id name postal_code country prefecture city ward
                      sublocality_level_1 sublocality_level_2 sublocality_level_3
                      sublocality_level_4 sublocality_level_5 sublocality_level_6
                      lat lng formatted_address
                      formatted_phone_number url website vicinity].freeze

    module_function

    def convert(query_col = 'query', input, output) # rubocop:disable all
      header = HEADER_ARRAY
      CSV.open(output, 'w') do |csv|
        csv << header
        CSV.foreach(input, headers: true) do |row|
          query = row[query_col]
          csv << get(query, header)
        end
      end
    end

    def get(query, keys = [])
      text_search_results = CustomGoogleMap::TextSearch.get_results(query)
      name = CustomGoogleMap::TextSearch.extract(text_search_results, 'name')
      place_id = CustomGoogleMap::TextSearch.extract(text_search_results, 'place_id')
      place_id_result = CustomGoogleMap::PlaceIdSearch.get_result(place_id)
      output = keys.each_with_object({}) do |key, obj|
        obj[key] = CustomGoogleMap::PlaceIdSearch.extract(place_id_result, key)
      end
      output.merge!('query' => query,
                    'name' => name,
                    'place_id' => place_id,
                    'vicinity' => custom_vicinity(output['vicinity'], output['prefecture'], output['city']))
      keys.map { |key| output[key] }
    end

    def custom_vicinity(value, prefecture, city)
      return nil if value.blank?

      value.strip!
      value.tr!('０-９ａ-ｚＡ-Ｚ　', '0-9a-zA-Z ')
      value.gsub!(/−/, '-')

      value.gsub!(/丁目 /, '')
      value.gsub!(/丁目([0-9])/, '-\1')
      value.gsub!(/丁([0-9])/, '-\1')
      value.gsub!(/番地([0-9])/, '-\1')
      value.gsub!(/番([0-9])/, '-\1')
      value.gsub!(/([0-9])番地$/, '\1')
      value.gsub!(/([0-9])号$/, '\1')
      value.gsub!(/丁目 /, ' ')
      value.gsub!(/^#{prefecture}/, '') if prefecture.present?
      value.strip!
      value.gsub!(/^#{city}/, '') if city.present?
      value.strip!
      value
    end

    def preprocess(input, output)
      header = %w[id name venue_name prefecture json]
      CSV.open(output, 'w') do |csv|
        csv << header
        CSV.foreach(input, headers: true) do |row|
          json = JSON.generate('venue' => row['venue_name']&.split('、'),
                               'place' => row['prefecture'])
          csv << [
            row['id'], row['name'], row['venue_name'], row['prefecture'],
            json
          ]
        end
      end
    end
  end

  module TextSearch
    TEXT_SEARCH_URL_BASE = 'https://maps.googleapis.com/maps/api/place/textsearch/json'

    module_function

    def get_results(keyword)
      results = text_search(keyword)
      # TODO: refactor
      return nil if results.nil? || results['results']&.length == 0 # rubocop:disable Style/NumericPredicate
      results['results'] # results_hash
    end

    def text_search(keyword)
      sleep(SLEEP_WAIT)
      begin
        client = HTTPClient.new(default_header: { 'Accept-Language' => LANGUAGE })
        response = client.get(TEXT_SEARCH_URL_BASE,
                              query: { key: GOOGLE_PLACES_API_KEY, query: keyword })
        JSON.parse(response.body)
      rescue StandardError
        nil
      end
    end

    def extract(results_hash, key)
      case key
      when 'place_id'
        first_place_id(results_hash)
      when 'name'
        first_name(results_hash)
      end
    end

    def first_place_id(results_hash)
      # TODO: refactor
      return nil if results_hash.nil? || results_hash&.length == 0 # rubocop:disable Style/NumericPredicate
      results_hash.first['place_id']
    end

    def first_name(results_hash)
      return nil if results_hash.nil? || results_hash&.length == 0 # rubocop:disable Style/NumericPredicate
      (results_hash.select { |r| r['place_id'] == first_place_id(results_hash) })[0]['name']
    end
  end

  module PlaceIdSearch
    PLACE_ID_URL_BASE = 'https://maps.googleapis.com/maps/api/place/details/json'

    module_function

    def get_result(place_id)
      result = place_id_search(place_id)
      # TODO: refactor
      return nil if result.nil? || result['result']&.length == 0 # rubocop:disable Style/NumericPredicate
      result['result'] # result_hash
    end

    def place_id_search(place_id)
      sleep(SLEEP_WAIT)
      begin
        client = HTTPClient.new(default_header: { 'Accept-Language' => LANGUAGE })
        response = client.get(PLACE_ID_URL_BASE,
                              query: { placeid: place_id, languqage: LANGUAGE, key: GOOGLE_PLACES_API_KEY })
        return JSON.parse(response.body)
      rescue StandardError
        ''
      end
    end

    def extract(result_hash, key) # rubocop:disable all
      return nil if result_hash.nil?
      case key
      when 'location_lat', 'lat'
        result_hash.dig('geometry', 'location', 'lat')
      when 'location_lng', 'lng'
        result_hash.dig('geometry', 'location', 'lng')
      when 'viewport_northeast_lat'
        result_hash.dig('geometry', 'viewport', 'northeast', 'lat')
      when 'viewport_northeast_lng'
        result_hash.dig('geometry', 'viewport', 'northeast', 'lng')
      when 'viewport_southwest_lat'
        result_hash.dig('geometry', 'viewport', 'southwest', 'lat')
      when 'viewport_southwest_lng'
        result_hash.dig('geometry', 'viewport', 'southwest', 'lng')
      when 'postal_code', 'country', 'ward', 'administrative_area_level_2', 'route', 'street_number', 'floor', 'sublocality_level_1', 'sublocality_level_2', 'sublocality_level_3', 'sublocality_level_4', 'sublocality_level_5'
        address_component = result_hash['address_components'].select { |a| a['types'].include?(key) }
        address_component[0]['long_name'] unless address_component.empty?
      when 'administrative_area_level_1', 'prefecture'
        address_component = result_hash['address_components'].select { |a| a['types'].include?('administrative_area_level_1') }
        address_component[0]['long_name'] unless address_component.empty?
      when 'city'
        address_component = result_hash['address_components'].select { |a| a['types'].include?('locality') && !a['types'].include?('ward') }
        address_component[0]['long_name'] unless address_component.empty?
      when 'open_now', 'weekday_text'
        result_hash.dig('opening_hours', key)
      else
        result_hash&.dig(key)
      end
    end
  end
end
