# frozen_string_literal: true

namespace :thumbnail do
  task event_url: :environment do
    # rails 'thumbnail:event_url'
    Event.where.not(url: nil).order(start_at: :desc).offset(1084).each.with_index do |event, i|
      Rails.logger.info "#{i} #{event.id} #{event.name} #{event.start_at} #{event.url}"
      event.put_thumbnail(100, 100)
      event.put_thumbnail(600, 600)
    end
    Rails.logger.info('Event url thubnail are exported to S3 dokode-thumbnail')
  end
  task event_url_google: :environment do
    # rails 'thumbnail:event_url'
    Event.where(url: nil).order(start_at: :desc).offset(741).each.with_index do |event, i|
      Rails.logger.info "#{i} #{event.id} #{event.name} #{event.start_at} #{event.uri}"
      event.put_thumbnail(100, 100)
      event.put_thumbnail(600, 600)
    end
    Rails.logger.info('Event url thubnail are exported to S3 dokode-thumbnail')
  end
end
