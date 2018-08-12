# frozen_string_literal: true

ActiveAdmin.register Venue do
  active_admin_import(
    before_import: proc { Venue.delete_all }
  )

  permit_params do
    Venue.column_names.map(&:to_sym)
  end
end
