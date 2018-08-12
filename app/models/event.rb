# frozen_string_literal: true

class Event < ApplicationRecord
  has_secure_token :token
  has_many :event_venues, inverse_of: :event, dependent: :nullify
  has_many :venues, through: :event_venues, inverse_of: :events
  has_many :communications, dependent: :nullify
  # validates :name, presence: true, length: {in: 1..255}
  # validates :url, length: {in: 1..1000}, unless: Proc.new {|a| a.url.blank?}
  before_validation :set_attributes

  BUCKET = 'dokode-thumbnail'

  def self.import_dynamodb(table_name, loop_max = 3)
    dynamodb_scan(table_name, loop_max) do |results, _loop_num|
      results.items.each do |item|
        find_by(id: item['id']).update(related_events: { rank: JSON.parse(item['rank']), query: item['string'] })
      end
    end
  end

  def put_thumbnail(width = 100, height = 100)
    false unless url
    false unless google_cse_result

    screen_capture = ScreenshotCapture.new(url: URI.decode_www_form_component(uri), height: height, width: width)
    image = screen_capture.resized_image
    put_png_to_s3(screen_capture.resized_image, BUCKET, "#{token}_#{width}x#{height}.png") if image.present?
  end

  def uri
    url || google_cse_result[0]['link']
  end

  private

  def set_attributes
    self.name = normalize_neologd(name.unicode_normalize(:nfkc))
    self.url = normalize_str_for_url(url) if url.present?
    self.end_at = start_at.end_of_day if start_at.present? && end_at.nil?
    self.content ||= name
  end

  def s3
    @s3 ||= Aws::S3::Client.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
  end

  def put_png_to_s3(png, bucket, key)
    s3
    @s3.put_object(
      bucket: bucket,
      key: key,
      body: png,
      content_type: 'image/png'
    )
  end
end
