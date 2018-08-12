class CreateEventVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :event_venues do |t|
      t.string :token
      t.integer :event_id
      t.string :place_id
      t.string :name
      t.string :prefecture
      t.string :address
      t.timestamps
    end
    add_index :event_venues, :event_id
  end
end
