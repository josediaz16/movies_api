module Errors

  GetRealField = -> field, subfield do
    case subfield
    when Integer
      "#{field}[#{subfield}]"
    when Symbol
      [field, subfield].join(".")
    end.to_s
  end.curry

  GetCodeAndMessage = -> str do
    str.first.split("~").map(&:strip).map(&:to_s)
  end

  class DryResult
    attr_reader :result, :output, :new_error

    def initialize(result, object_class)
      @result = result
      @new_error = Errors::Simple.lazy.(object_class)
      @output = result.output
    end

    def parse
      result.errors.each_with_object([]) do |(field, description), array|
        array.concat recursive_parse(field, description, output.dig(field))
      end
    end

    def parse_with_subfields(field, description)
      description.each_with_object([]) do |(subfield, subdescription), array|
        real_field = GetRealField.(field, subfield)
        array.concat recursive_parse(real_field, subdescription, output.dig(field, subfield))
      end
    end

    def recursive_parse(field, description, value)
      case description
      when Hash
        parse_with_subfields(field, description)
      when Array
        code, message = GetCodeAndMessage.(description)
        [new_error.(field.to_s, code.to_s, message.to_s, value)]
      end
    end

  end
end
