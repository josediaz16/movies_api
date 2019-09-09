module Errors
  class Simple
    def initialize(object_class:, field:, code:, description:, value: nil, &block)
      @base = OpenStruct.new(
        object_class: object_class,
        field: field,
        code: code,
        description: description,
        value: value,
        extra: {}
      )
      @block = block
    end
  
    def self.lazy
      -> object_class, field, code, description, value do
        self.new(object_class: object_class.to_s, field: field, code: code, description: description, value: value).parse
      end.curry
    end
  
    def parse
      @base.to_h.tap do |error|
        @block.call(error[:extra]) if @block
      end
    end
  end
end
