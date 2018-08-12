# frozen_string_literal: true

module ApplicationHelper
  def search_btn_to(keyword)
    link_to keyword, search_path(event_search: { keyword: keyword }), class: 'text-white badge badge-pill badge-primary mr-2 mb-1'
  end
end
