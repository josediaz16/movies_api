Sequel.migration do
  up do
    add_column :movies, :created_at, DateTime, null: false
    add_column :movies, :updated_at, DateTime, null: false
    add_column :show_days, :created_at, DateTime, null: false
    add_column :show_days, :updated_at, DateTime, null: false
    add_column :movies_show_days, :created_at, DateTime, null: false
    add_column :movies_show_days, :updated_at, DateTime, null: false
  end
end
