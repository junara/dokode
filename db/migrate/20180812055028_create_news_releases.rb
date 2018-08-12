class CreateNewsReleases < ActiveRecord::Migration[5.2]
  def change
    create_table :news_releases do |t|
      t.text   :body
      t.datetime :published_at
      t.timestamps
    end
  end
end
