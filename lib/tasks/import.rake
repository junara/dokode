# frozen_string_literal: true

namespace :import do
  task :delete_all_and_import_all_with_callback, %w[path col_sep] => :environment do |task, args|
    # rake 'import:delete_all_and_import_all_with_callback'

    col_sep = args[:col_sep] || ','
    path = args[:path] || 'db/data/import.csv'
    unless File.exist?(path)
      Rails.logger.error("#{path} is not existed. Rake task (#{task}) is aborted")
      next
    end
    Event.delete_all_and_import_all_with_callback(path: path, col_sep: col_sep)
    Rails.logger.info("#{file_path} is imported. Rake task (#{task}) is done")
  end

  task :simple_import_with_callback, %w[path col_sep] => :environment do |task, args|
    # rake 'import:simple_import_with_callback'

    col_sep = args[:col_sep] || ','
    path = args[:path] || 'db/data/import.csv'
    unless File.exist?(path)
      Rails.logger.error("#{path} is not existed. Rake task (#{task}) is aborted")
      next
    end
    Event.simple_import_with_callback(path: path, col_sep: col_sep)
    Rails.logger.info("#{path} is imported. Rake task (#{task}) is done")
  end
end
