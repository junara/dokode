# frozen_string_literal: true

ActiveAdmin.register NewsRelease do
  active_admin_import(
    before_import: proc { NewsRelease.delete_all }
  )

  permit_params do
    NewsRelease.column_names.map(&:to_sym)
  end
end
