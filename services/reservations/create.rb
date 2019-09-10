require 'dry-transaction'
require './services/common/crud'
require './validators/reservations'
require './models/reservation'

module Reservations
  class Create
    include Dry::Transaction
    include Common::ApiResponse

    step :validate_input
    map  :parse_input
    step :persist

    def validate_input(input)
      Common::Validate.new(Validators::Reservations).(input)
    end

    def parse_input(input)
      {attributes: input, original: input}
    end

    def persist(input)
      Common::Insert.new(Reservation).(input)
    end
  end
end
