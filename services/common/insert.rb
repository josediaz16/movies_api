require 'dry/transaction/operation'
require './lib/errors/sequel_error'

module Common
  class Insert
    include Dry::Transaction::Operation

    attr_reader :model
    def initialize(model)
      @model = model
    end

    def call(attributes:, **other_input)
      record = model.new(attributes)
      if record.valid?
        record.save
        Success model: record, **other_input
      else
        Failure errors: Errors::SequelError.new(record)
      end
    end
  end
end
