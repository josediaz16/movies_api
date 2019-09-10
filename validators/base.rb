require 'dry-validation'
require_relative 'predicates'

module Validators
  class Base < Dry::Validation::Schema
    configure do
      # Use custom validation rules
      predicates ::Validators::Predicates
      # Remove any key that is not defined by the validator
      config.input_processor = :sanitizer
      # Use I18n as engine for error messages
      config.messages_file = 'config/errors.yml'
      # Use Dry::Types for validation and coercion
      config.type_specs = true

      option :object_class

      def provided?(value)
        value.present?
      end

      def exists?(model_class, value)
        model_class.where(id: value).any?
      end
    end
  end
end
