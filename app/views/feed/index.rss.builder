# frozen_string_literal: true

xml.instruct! :xml, version: '1.0'
xml.rss('version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/') do
  xml.channel do
    xml.title 'dokode'
    xml.description '理系の学会・研究会'
    xml.link 'https://www.dokode.work/'
    @events.each do |event|
      xml.item do
        xml.title event.name
        xml.description event.content
        xml.pubDate event.created_at
        xml.guid event_url(token: event.token)
        xml.link event_url(token: event.token, utm_source: 'feed')
      end
    end
  end
end
