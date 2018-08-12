class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :token
      t.string :name
      t.string :url
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :flag_all_day, default: true
      t.text :content
      t.timestamps
    end
  end
end
