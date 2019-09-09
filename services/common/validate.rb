require 'dry/transaction/operation'
require 'active_support'

module Common
  class Validate
    include Dry::Transaction::Operation

    attr_reader :validator

    def initialize(validator)
      @validator = validator
    end

    def call(input)
      data = input.to_h
      result = validator.(data)

      if result.success?
        Success input.deep_merge(result.output)
      else
        Failure attributes: data, errors: result, object_class: validator.options[:object_class]
      end
    end
  end
end
