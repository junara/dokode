# frozen_string_literal: true

module LambdaUploader
  module_function

  def start_calc(limit = nil)
    bucket = 'dokode'
    events = Event.all.order(id: :asc).limit(limit)
    events.each do |event|
      body = {
        id: event.id,
        string: filter_word(event.name)
      }
      key = "title/data/#{event.id}.json"
      put_json_to_s3(body, bucket, key)
    end
  end

  def put_events_to_s3
    bucket = 'dokode'
    key = 'title/template/template.json'
    Rails.logger.info "Start output #{key}."
    events = Event.all.map do |event|
      {
        id: event.id,
        string: filter_word(event.name)
      }
    end
    put_json_to_s3(events, bucket, key)
    Rails.logger.info "Output expert_words to #{key} in S3."
  end

  def s3
    @s3 ||= Aws::S3::Client.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
  end

  def put_json_to_s3(data, bucket, key)
    s3
    @s3.put_object(
      bucket: bucket,
      key: key,
      body: data.to_json,
      content_type: 'application/json'
    )
  end

  def filter_word(word)
    word.gsub!(/第\d{1,3}回/, '')
    word.gsub!(/第\d{1,3}次/, '')
    word.gsub!(/20\d{2,2}/, '')
    word.gsub!(/平成\d{2,2}年度/, '')
    word.gsub!(/平成\d{2,2}年/, '')
    word.gsub!(/平成\d{2,2}度/, '')
    word.gsub!(/学術会|学術総会|学術集会|学会|総会|年会|講演|フォーラム|セミナー|研究会|シンポジウム|討論会|学術大会|大会|部門|懇談会|レクチャー|コンファレンス|カンファレンス|集談会|講座|会議|談話|談話会|ワークショップ/, '')
    word.gsub!(/日本|国際|全国|ジャパン|japan|/, '')
    word.gsub!(/通常|共催|合同|ジョイント|コングレス/, '')
    word.gsub!(/サイエンス|カフェ/, '')
    word.gsub!(/新技術説明会|・|ならびに|学校|会場|年次|スペシャル|クラブ|ライブ|ネットワーク|サマー|技術/, '')
    word.gsub!(/地方会|地方|支部会|報告会|症例|アジア|太平洋|支部|財団|西支部|部会|例会/, '')
    word.gsub!(/北海道|東北|関東|甲信越|北陸|近畿|四国|山陰|山陽|九州|沖縄|東京|首都圏|中部|関西|中国|中四国|名古屋|大阪|福岡|熊本/, '')
    word.gsub!(/学術会|学術総会|学術集会|学会|総会|年会|講演|フォーラム|セミナー|研究会|シンポジウム|討論会|学術大会|大会|部門|懇談会/, '')
    word
  end
end
