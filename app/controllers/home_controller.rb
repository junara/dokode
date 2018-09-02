# frozen_string_literal: true

class HomeController < ApplicationController
  include Pagy::Backend
  def index
    @event_search = EventSearch.new
    @news_releases = NewsRelease.order(published_at: :desc)
  end

  def search
    @event_search = if params[:event_search].present?
                      EventSearch.new(event_search_params)
                    else
                      EventSearch.new
                    end
    @pagy, @events = pagy(@event_search.exec.includes(:venues))
  end

  private

  def event_search_params
    params.require(:event_search).permit(:keyword)
  end
end
