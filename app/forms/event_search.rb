# frozen_string_literal: true

class EventSearch
  include ActiveModel::Model
  include CustomNormalizer
  attr_accessor(:keyword, :start_date, :display_limit)
  DEFAULT_KEYWORD = '第 会'
  DEFAULT_DISPLAY_LIMIT = 10
  DEFAULT_START_DATE = Time.current.beginning_of_day.to_s

  def initialize(attributes = {})
    super
    @start_date ||= DEFAULT_START_DATE
    @display_limit ||= DEFAULT_DISPLAY_LIMIT
  end

  def exec
    Event.search(search_params).result.order(start_at: :asc).limit(@display_limit)
  end

  def keyword_array
    normalize_str(@keyword).split(' ')
  end

  def search_params
    keys = normalize_str(@keyword).split(' ')
    {
      content_cont_all: keys,
      start_at_gteq: @start_date
    }
  end
end
