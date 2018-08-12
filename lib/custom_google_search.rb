# frozen_string_literal: true

require 'httpclient'
require 'json'

module CustomGoogleSearch
  GOOGLE_API_KEY = ENV['GOOGLE_API_KEY']
  LANGUAGE = 'ja'
  SLEEP_WAIT = 2
  SEARCH_ENGINE_ID = ENV['SEARCH_ENGINE_ID']
  BASE_URL = 'https://www.googleapis.com/customsearch/v1'

  module_function

  def get_items(keyword)
    results = text_search(keyword)
    return nil if results.nil? || results['items']&.length == 0 # rubocop:disable Style/NumericPredicate
    results['items']
  end

  def get_first_item(keyword)
    items = get_items(keyword)
    items && items[0]
  end

  def text_search(keyword)
    sleep(SLEEP_WAIT)
    begin
      client = HTTPClient.new(default_header: { 'Accept-Language' => LANGUAGE })
      response = client.get(BASE_URL,
                            query: { key: GOOGLE_API_KEY, cx: SEARCH_ENGINE_ID, q: keyword })
      JSON.parse(response.body)
    rescue StandardError
      nil
    end
  end
end
