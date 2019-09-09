require 'dry/transaction/operation'
require './lib/errors/sequel_error'

module Common
  class Insert
    include Dry::Transaction::Operation

    attr_reader :model
    def initialize(model)
      @model = model
    end

    def call(input)
      record = model.new(input)
      if record.valid?
        record.save
        Success model: record
      else
        Failure errors: Errors::SequelError.new(record)
      end
    end
  end
end
