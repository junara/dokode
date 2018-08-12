# frozen_string_literal: true

namespace :google_cse_result do
  task get_all: :environment do
    # rails 'thumbnail:event_url'
    Event.where(google_cse_result: nil).order(start_at: :desc).each.with_index do |event, i|
      Rails.logger.info "#{i} #{event.id} #{event.name} #{event.start_at} #{event.url}"
      items = CustomGoogleSearch.get_items(event.name)
      event.update(google_cse_result: items) if items.present?
    end
    Rails.logger.info('Event url thubnail are exported to S3 dokode-thumbnail')
  end
end
