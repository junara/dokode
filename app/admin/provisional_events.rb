# frozen_string_literal: true

ActiveAdmin.register ProvisionalEvent do
  active_admin_import(
    before_import: proc { ProvisionalEvent.delete_all }
  )

  permit_params do
    ProvisionalEvent.column_names.map(&:to_sym)
  end
end
