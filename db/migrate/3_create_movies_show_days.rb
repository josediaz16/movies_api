Sequel.migration do
  up do
    create_join_table(movie_id: :movies, show_day_id: :show_days)
  end
end
