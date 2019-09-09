require 'dry-transaction'
require './services/common/validate'
require './validators/movies'
require './models/movie'
require './lib/errors/sequel_error'
require './lib/errors/parser'

module Movies
  class Create
    include Dry::Transaction

    step :validate_input
    step :persist

    def call(input)
      super(input) do |transaction|
        transaction.success { |value| Success value }
        transaction.failure do |error|
          errors, object_class = error.slice(:errors, :object_class).values
          Failure errors: Errors::Parser.detect(errors, object_class).parse
        end
      end
    end

    def validate_input(input)
      Common::Validate.new(Validators::Movies).(input)
    end

    def persist(input)
      movie = Movie.new(input)
      if movie.valid?
        movie.save
        Success model: movie
      else
        Failure errors: Errors::SequelError.new(movie)
      end
    end
  end
end
