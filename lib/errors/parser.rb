require_relative 'utils'

# This class is a centralized way to parse errors
# Stores an array of errors and map them using the
# contract .parse on each error.
class Errors::Parser

  # Creates a parser with a simple error
  def self.simple_error(object_class: :generic, field:, code:, description:, &block)
    new Errors::Simple.new(object_class: object_class, field: field, code: code, description: description, &block)
  end

  # Creates a parser with a class based error.
  def self.detect(error, *args, &block)
    new Errors::Utils.detect(error, *args, &block)
  end

  attr_reader :errors

  # An array or a single error that must respond to .parse
  def initialize(errors)
    @errors = [errors].compact.flatten
  end

  def parse
    @errors.map(&:parse).flatten
  end

  # Adds a new error to the parser with a class based error.
  def detect_and_add(error, &block)
    add Errors::Utils.detect(error, &block)
  end

  # Adds a new error to the parser
  def add(error)
    @errors << error
  end
end
