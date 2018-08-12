class AddGoogleCseResult < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :google_cse_result, :jsonb
  end
end
