# frozen_string_literal: true

ActiveAdmin.register EventVenue do
  active_admin_import(
    before_import: proc { EventVenue.delete_all }
  )

  permit_params do
    EventVenue.column_names.map(&:to_sym)
  end
end
