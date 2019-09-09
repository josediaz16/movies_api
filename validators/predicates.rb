require 'dry-validation'

module Validators
  module Predicates
    include Dry::Logic::Predicates

    predicate(:valid_url?) do |value|
      !value.match(/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix).nil?
    end
  end
end
