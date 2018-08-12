# frozen_string_literal: true

module CustomImport
  # To use this import module you need active_admin_import gem.
  # ActiveRecord is extended by this and get simple_import class method !
  require 'csv'

  def delete_all_and_import_all(path: '', col_sep: ',')
    delete_all
    initialize_seq_id
    simple_import(path: path, col_sep: col_sep)
  end

  def simple_import(path: '', col_sep: ',')
    a = []
    CSV.foreach(path, headers: true, col_sep: col_sep) do |r|
      a << new(get_import_params(r))
    end
    import a # activerecord-importのメソッドです。
  end

  def delete_all_and_import_all_with_callback(path: '', col_sep: ',')
    delete_all
    initialize_seq_id
    simple_import_with_callback(path: path, col_sep: col_sep)
  end

  def simple_import_with_callback(path: '', col_sep: ',')
    CSV.foreach(path, headers: true, col_sep: col_sep) do |r|
      create(get_import_params(r))
    end
  end

  def get_import_params(row)
    headers = row.headers & column_names # 存在するカラム名のみに限定する
    headers.each_with_object({}) do |c, h|
      h[c.to_sym] = row.field(c)
    end
  end

  def initialize_seq_id
    ActiveRecord::Base.connection.execute("select setval ('#{table_name}_id_seq', 1, false);")
  end
end
