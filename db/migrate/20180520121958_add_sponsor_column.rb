class AddSponsorColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :sponsor, :string
    add_column :events, :sponsor_url, :string
    add_column :events, :organizer, :string
    add_column :events, :organizer_affiliation, :string
    add_column :events, :source, :string
    add_column :events, :category, :string
    add_column :events, :country, :string
    add_column :events, :num_event, :integer
  end
end
