require 'dry-transaction'
require './services/common/crud'
require './validators/movies'
require './models/movie'

module Movies
  class Create
    include Dry::Transaction
    include Common::ApiResponse

    step :validate_input
    step :persist

    def validate_input(input)
      Common::Validate.new(Validators::Movies).(input)
    end

    def persist(input)
      Common::Insert.new(Movie).(input)
    end
  end
end
