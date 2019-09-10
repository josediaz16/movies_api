Sequel.migration do
  up do
    create_table(:reservations) do
      primary_key :id
      String :document, null: false, default: ""
      Integer :reservation_count, null: false, default: 0
      Date :reservation_date, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end

    alter_table(:reservations) { add_foreign_key :movie_id, :movies }
  end
end
