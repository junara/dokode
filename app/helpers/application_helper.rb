# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  def search_btn_to(keyword)
    link_to keyword, search_path(event_search: { keyword: keyword }), class: 'text-white badge badge-pill badge-primary mr-2 mb-1'
  end

  def default_meta_tags
    {
      title: 'dokode',
      description: '気になるあの学会をさがそう',
      keywords: '理系,学会,研究会',
      charset: 'UTF-8',
      site: 'dokode',
      og: {
        title: 'dokode',
        type: 'website',
        url: request.original_url,
        site_name: '気になるあの学会をさがそう',
        description: '',
        locale: 'ja_JP',
        image: { _: image_url('ogp_image.png'), width: 600, height: 600 }
      },
      twitter: {
        card: 'summary',
        site: '@junara783'
      }
    }
  end

  def event_show_meta_tags(event)
    {
      title: "#{event.name} の紹介",
      og: {
        title: "dokode | #{event.name} の紹介",
        type: 'website',
        url: request.original_url,
        site_name: '気になるあの学会をさがそう',
        description: "開催日 #{event.display_start_at} | 開催場所 #{event.display_places}",
        locale: 'ja_JP',
        image: { _: image_url(event.thumbnail(600)), width: 600, height: 600 }
      },
      twitter: {
        card: 'summary',
        site: '@junara783'
      }
    }
  end

  def events_search_results_meta_tags(event_search, _events)
    {
      title: "#{event_search.keyword} の検索結果一覧",
      description: '気になるあの学会をさがそう',
      keywords: '理系,学会,研究会',
      charset: 'UTF-8',
      site: 'dokode',
      og: {
        title: "#{event_search.keyword} の検索結果一覧",
        type: 'website',
        url: request.original_url,
        site_name: 'dokode | 気になるあの学会をさがそう',
        description: '',
        locale: 'ja_JP',
        image: { _: image_url('ogp_image.png'), width: 600, height: 600 }
      },
      twitter: {
        card: 'summary',
        site: '@junara783'
      }
    }
  end
end
