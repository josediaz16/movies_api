Sequel.migration do
  up do
    create_table(:movies) do
      primary_key :id
      String :name, null: false, default: ""
      String :description, null: false, default: ""
      String :image_url, null: false, default: ""
    end
  end
end
