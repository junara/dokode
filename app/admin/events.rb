# frozen_string_literal: true

ActiveAdmin.register Event do
  active_admin_import(
    before_import: proc { Event.delete_all }
  )

  permit_params do
    Event.column_names.map(&:to_sym)
  end
end
