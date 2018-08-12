class AddRelatedEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :related_events, :jsonb
  end
end
