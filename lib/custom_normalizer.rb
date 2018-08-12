# frozen_string_literal: true

module CustomNormalizer
  require 'moji'
  def normalize_neologd(norm)
    # see https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja
    norm.tr!('０-９Ａ-Ｚａ-ｚ', '0-9A-Za-z')
    norm = Moji.han_to_zen(norm, Moji::HAN_KATA)
    hypon_reg = /(?:˗|֊|‐|‑|‒|–|⁃|⁻|₋|−)/
    norm.gsub!(hypon_reg, '-')
    choon_reg = /(?:﹣|－|ｰ|—|―|─|━)/
    norm.gsub!(choon_reg, 'ー')
    chil_reg = /(?:~|∼|∾|〜|〰|～)/
    norm.gsub!(chil_reg, '')
    norm.gsub!(/[ー]+/, 'ー')
    norm.tr!(%q{!"#$%&'()*+,-.\/:;<=>?@[¥]^_`{|}~｡､･｢｣"}, '！”＃＄％＆’（）＊＋，－．／：；＜＝＞？＠［￥］＾＿｀｛｜｝〜。、・「」')
    norm.gsub!(/　/, ' ')
    norm.gsub!(/ {1,}/, ' ')
    norm.gsub!(/^[ ]+(.+?)$/, '\\1')
    norm.gsub!(/^(.+?)[ ]+$/, '\\1')
    while norm =~ /([\p{InCjkUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)[ ]{1}([\p{InCjkUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)/
      norm.gsub!(/([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)/, '\\1\\2')
    end
    while norm =~ /([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)/
      norm.gsub!(/([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)/, '\\1\\2')
    end
    while norm =~ /([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)/
      norm.gsub!(/([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)/, '\\1\\2')
    end
    norm.tr!(
      '！”＃＄％＆’（）＊＋，－．／：；＜＞？＠［￥］＾＿｀｛｜｝〜',
      %q{!"#$%&'()*+,-.\/:;<>?@[¥]^_`{|}~}
    )
    norm
  end

  def trim_tab(norm)
    norm.gsub!(/^¥t+(.+?)$/, '\\1')
    norm.gsub!(/^(.+?)¥t+$/, '\\1')
    norm
  end

  def normalize_str(norm)
    # see https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja
    norm.tr!('０-９Ａ-Ｚａ-ｚ', '0-9A-Za-z')
    norm = Moji.han_to_zen(norm, Moji::HAN_KATA)
    hypon_reg = /(?:˗|֊|‐|‑|‒|–|⁃|⁻|₋|−)/
    norm.gsub!(hypon_reg, '-')
    choon_reg = /(?:﹣|－|ｰ|—|―|─|━)/
    norm.gsub!(choon_reg, 'ー')
    chil_reg = /(?:~|∼|∾|〜|〰|～)/
    norm.gsub!(chil_reg, '')
    norm.gsub!(/[ー]+/, 'ー')
    norm.tr!(%q{!"#$%&'()*+,-.\/:;<=>?@[¥]^_`{|}~｡､･｢｣"}, '！”＃＄％＆’（）＊＋，－．／：；＜＝＞？＠［￥］＾＿｀｛｜｝〜。、・「」')
    norm.gsub!(/　/, ' ')
    norm.gsub!(/ {1,}/, ' ')
    norm.gsub!(/^[ ]+(.+?)$/, '\\1')
    norm.gsub!(/^(.+?)[ ]+$/, '\\1')

    norm.tr!(
      '！”＃＄％＆’（）＊＋，－．／：；＜＞？＠［￥］＾＿｀｛｜｝〜',
      %q{!"#$%&'()*+,-.\/:;<>?@[¥]^_`{|}~}
    )
    norm
  end
end
