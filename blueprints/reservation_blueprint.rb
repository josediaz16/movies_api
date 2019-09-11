require 'blueprinter'
require_relative 'movie_blueprint'

class ReservationBlueprint < Blueprinter::Base
  identifier :id
  fields :reservation_count, :reservation_date

  association :movie, blueprint: MovieBlueprint
end
