Rails.application.config.assets.configure do |env| # rubocop:disable all
  env.register_mime_type('application/manifest+json', extensions: ['.webmanifest'])
end
