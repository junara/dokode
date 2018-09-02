# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # herokuapp.comから独自ドメインへリダイレクト
  before_action :ensure_domain
  FQDN = 'www.dokode.work'

  # redirect correct server from herokuapp domain for SEO
  def ensure_domain
    return unless /\.herokuapp.com/ =~ request.host

    # 主にlocalテスト用の対策80と443以外でアクセスされた場合ポート番号をURLに含める
    port = ":#{request.port}" unless [80, 443].include?(request.port)
    redirect_to "#{request.protocol}#{FQDN}#{port}#{request.path}", status: :moved_permanently
  end
end
