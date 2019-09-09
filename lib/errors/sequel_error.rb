require 'active_support/inflector'
require_relative 'simple'

module Errors
  class SequelError < Struct.new(:model, :block)

    def with_block(block)
      self.tap do
        self.block = block
      end
    end

    def parse
      new_error = Errors::Simple.lazy.(object_class)
      model.errors.each_with_object([]) do |(field, messages), array|

        messages.each do |message|
          array << new_error.(field.to_s, message.split(' ').last, message.to_s, model.values[field], &self.block)
        end
      end
    end

    private

    def object_class
      model.class.to_s.underscore
    end
  end
end
