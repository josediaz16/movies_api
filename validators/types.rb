require 'dry-validation'

module Validators
  module Types
    include Dry::Types.module

    IntArray = Types::Array.constructor do |value|
      value.map(&:to_i)
    end
  end
end
