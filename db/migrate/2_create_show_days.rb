Sequel.migration do
  up do
    create_table(:show_days) do
      primary_key :id
      Integer :day_number, null: false
      String :name, null: false, default: ""
    end
  end
end
