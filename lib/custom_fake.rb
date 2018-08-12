# frozen_string_literal: true

module CustomFake
  module_function

  def event_name
    [
      %W[日本 米国 欧州 国際 第#{rand(1..100)}回],
      %w[細胞 タンパク DNA RNA 遺伝],
      %w[XXXX YYYY ZZZZ ABCD EFGH あいうえ かきくけ ○×△ さしすせ たちつて なにぬね はひふへ まみむめ やゆよ],
      %w[XXXX YYYY ZZZZ ABCD EFGH あいうえ かきくけ ○×△ さしすせ たちつて なにぬね はひふへ まみむめ やゆよ],
      %w[癌 肝臓 循環器 膵臓],
      %w[治療 検査 統計 癌 肝臓 循環器 膵臓],
      %w[研究会 セミナー 勉強会 学会 総会 講演会]
    ].map(&:sample).join
  end

  def event_url
    %w[https://news.yahoo.co.jp/hl?c=loc https://news.yahoo.co.jp/hl?c=c_life https://news.yahoo.co.jp/hl?c=c_sci
       https://news.yahoo.co.jp/hl?c=bus https://news.yahoo.co.jp/hl?c=c_ent https://news.yahoo.co.jp/hl?c=c_spo
       https://google.com https://google.co.jp https://yahoo.com https://yahoo.co.jp https://news.yahoo.co.jp/
       https://news.yahoo.co.jp/hl?c=dom https://news.yahoo.co.jp/hl?c=c_int].sample
  end

  def event_start_at(date: Time.current, until_day: 365)
    date + rand(1..until_day).day
  end

  def event_end_at(start_at)
    start_at + rand(0..3).day
  end

  def event_content
    rand(10..500).times.map {event_name}.join # rubocop:disable all
  end

  def delete_and_create_event(sample_num)
    Event.delete_all
    Event.initialize_seq_id
    sample_num.times do
      name = event_name
      start_at = event_start_at(until_day: sample_num * 3)
      end_at = event_end_at(start_at)
      content = name + event_content
      params = {
        name: name,
        url: event_url,
        start_at: start_at,
        end_at: end_at,
        content: content
      }
      Event.create(params)
    end
  end
end
