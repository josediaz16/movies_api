require './lib/errors/parser'

module Common
  module ApiResponse

    def call(input)
      super(input) do |transaction|
        transaction.success { |value| Success value }

        transaction.failure do |error|
          errors, object_class = error.slice(:errors, :object_class).values
          Dry::Monads::Failure.new errors: Errors::Parser.detect(errors, object_class).parse
        end
      end
    end

  end
end
