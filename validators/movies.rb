require_relative 'base'
require_relative 'types'

module Validators
  Movies = Dry::Validation.Params(Validators::Base) do
    required(:name, Types::String).filled
    required(:description, Types::String).filled
    required(:image_url, Types::String).filled(:valid_url?)
    required(:show_days, Types::IntArray).each(included_in?: (1..7).to_a)
  end.with(object_class: :movie)
end
