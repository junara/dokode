# frozen_string_literal: true

class EventDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def start_at_year(digit = 4)
    digit == 4 ? start_at.strftime('%Y') : start_at.strftime('%y')
  end

  def start_at_month(digit = 2)
    format("%0#{digit}d", start_at.month)
  end

  def start_at_day(digit = 2)
    format("%0#{digit}d", start_at.day)
  end

  def end_at_month(digit = 2)
    format("%0#{digit}d", end_at.month)
  end

  def end_at_day(digit = 2)
    format("%0#{digit}d", end_at.day)
  end

  def ical(calendar_name = 'calendar') # rubocop:disable all
    calendar = ::Icalendar::Calendar.new
    calendar.append_custom_property('X-WR-CALNAME;VALUE=TEXT', "#{calendar_name} by ")
    event = ::Icalendar::Event.new
    event.created = created_at
    event.location = event_venues&.first&.name
    event.summary = "#{name}の予定"
    event.dtstart = flag_all_day ? start_at.to_date : start_at
    event.dtend = flag_all_day ? (end_at + 1.day).to_date : end_at
    event.dtstamp = created_at
    event.last_modified = updated_at
    event.description = "イベント名\n#{name}\n\nイベントURL\n#{display_url}\n\nThis is provided by Dokode.\nhttps://www.dokode.work\n"
    event.uid = token.to_s
    event.url = helpers.event_url(token: token)
    calendar.add_event(event)
    calendar.publish
    calendar.to_ical
  end

  def mail_body
    "イベント名\n#{name}\n\nイベントホームページ\n#{display_url}\n\n開催日時\n#{start_at} - #{end_at}"
  end

  def share_line
    "http://line.me/R/msg/text/?#{CGI.escape(name)}"
  end

  def share_twitter
    "https://twitter.com/intent/tweet?url=#{display_url}&text=#{CGI.escape("#{name}\n\n")}&hashtags=dokode"
  end

  def share_facebook
    "https://www.facebook.com/sharer/sharer.php?u=#{display_url}"
  end

  def thumbnail(width = 100)
    # return if url.blank? && google_cse_result.blank?
    # base = 'http://s.wordpress.com/mshots/v1/'
    # "#{base}#{URI.encode_www_form_component(url)}#{width ? ('?w=' + width.to_s) : ''}"
    "https://s3-ap-northeast-1.amazonaws.com/dokode-thumbnail/#{token}_#{width}x#{width}.png"
  end

  def display_url
    return url if url.present?
    return google_cse_result[0]['link'] if google_cse_result.present?
  end
end
