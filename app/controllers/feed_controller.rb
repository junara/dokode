# frozen_string_literal: true

class FeedController < ApplicationController
  def index
    @events = Event.order(created_at: :desc).limit(10).decorate
    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end
