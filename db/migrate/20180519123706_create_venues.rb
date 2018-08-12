class CreateVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :venues do |t|
      t.string :token
      t.string :place_id
      t.jsonb :result_cache, default: '{}'
      t.string :name
      t.string :postal_code
      t.string :country
      t.string :prefecture
      t.string :city
      t.string :ward
      t.string :formatted_address
      t.string :formatted_phone_number
      t.float :latitude
      t.float :longitude
      t.string :website
      t.timestamps
    end
    add_index :venues, :place_id
  end
end
