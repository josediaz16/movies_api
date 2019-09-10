require_relative 'base'
require_relative 'types'
require './models/reservation'
require './models/movie'

module Validators
  Reservations = Dry::Validation.Params(Validators::Base) do
    required(:document, Types::String).filled
    required(:movie_id, Types::Integer) { filled? & exists?(Movie) }
    required(:reservation_count, Types::Integer).filled(gt?: 0, lteq?: 10)
    required(:reservation_date, Types::Date).filled

    validate(max_reservations: %i[reservation_count reservation_date movie_id]) do |r_count, r_date, movie_id|
      Reservation.where(movie_id: movie_id, reservation_date: r_date).sum(:reservation_count).to_i + r_count <= 10
    end

    validate(available_movie: %i[reservation_date movie_id]) do |r_date, movie_id|
      Movie[movie_id]
        .show_days
        .map(&:day_number)
        .map(&:to_i)
        .include?(r_date.cwday)
    end
  end.with(object_class: :reservation)
end
