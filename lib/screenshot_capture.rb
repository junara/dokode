# frozen_string_literal: true

require 'selenium-webdriver'
require 'httpclient'
require 'mini_magick'
class ScreenshotCapture
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :url, :string
  attribute :height, :integer
  attribute :width, :integer

  DESKTOP_WINDOW_WIDTH = 1000
  MAX_WIDTH = 1000
  MAX_HEIGHT = 1000

  def initialize(args = {})
    super(args)
    @client = HTTPClient.new
  end

  def png_image
    nil unless valid?
    image = nil
    begin
      driver = Selenium::WebDriver.for :chrome, options: headless_chrome_options
      driver.navigate.to url
      # sleep(5)
      driver.manage.window.resize_to(DESKTOP_WINDOW_WIDTH, height && width ? DESKTOP_WINDOW_WIDTH * image_height / image_width : DESKTOP_WINDOW_WIDTH)
      # sleep(5)
      image = driver.screenshot_as(:png)
    rescue OpenSSL::SSL::SSLError, Selenium::WebDriver::Error, Net::ReadTimeout, Selenium::WebDriver::Error::UnknownError => e
      Rails.logger.error e
    end
    driver.close
    driver.quit
    image
  end

  def resized_image
    nil if png_image.blank?
    begin
      image = MiniMagick::Image.read(png_image)
      image.resize "#{image_width}x#{image_height}"
      image.to_blob
    rescue StandardError => e
      Rails.logger.error e
      nil
    end
  end

  def valid?
    false unless url
    false unless successful?
    true
  end

  def successful?
    @content ||= @client.get(url)
    HTTP::Status.successful?(@content.status)
  rescue Net::OpenTimeout, OpenSSL::SSL::SSLError, Net::ReadTimeout, URI::InvalidURIError, HTTPClient::ReceiveTimeoutError => e
    Rails.logger.error e
  end

  def image_width
    width&.between?(50, MAX_WIDTH) ? width : MAX_WIDTH
  end

  def image_height
    height&.between?(50, MAX_HEIGHT) ? height : MAX_HEIGHT
  end

  def headless_chrome_options
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-gpu')
    options.add_argument('--hide-scrollbars')
    options.binary = '/app/.apt/usr/bin/google-chrome' if heroku?
    options
  end

  def heroku?
    Rails.env.production?
  end
end
