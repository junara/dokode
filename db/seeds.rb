# frozen_string_literal: true

admin_user_email = ENV['ADMIN_USER_EMAIL'] ? ENV['ADMIN_USER_EMAIL'] : 'admin@example.com'
admin_user_password = ENV['ADMIN_USER_PASSWORD'] ? ENV['ADMIN_USER_PASSWORD'] : 'password'
AdminUser.create!(email: admin_user_email, password: admin_user_password, password_confirmation: admin_user_password)

CustomFake.delete_and_create_event(1000) if Rails.env.development? && Event.all.count.blank?
