class CreateProvisionalEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :provisional_events do |t|
      t.string :token
      t.string :name
      t.string :url
      t.string :sponsor
      t.string :sponsor_url
      t.string :organizer
      t.string :organizer_affiliation
      t.string :source
      t.string :category
      t.integer :num_event
      t.string :country
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :flag_all_day, default: true
      t.text :content
      t.jsonb :place
      t.jsonb :normalized_place
      t.timestamps
    end
  end
end
