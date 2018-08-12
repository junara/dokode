# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include CustomNormalizer
  extend CustomImport
  extend DynamodbClient

  self.abstract_class = true

  def normalize_str(norm)
    normalize_neologd(norm)
  end

  def normalize_str_for_url(norm)
    norm.strip!
    trim_tab(norm)
    norm
  end
end
