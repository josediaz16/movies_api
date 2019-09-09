require_relative 'base'

module Validators
  Movies = Dry::Validation.Params(Validators::Base) do
    required(:name).filled
    required(:description).filled
    required(:image_url).filled(:valid_url?)
  end.with(object_class: :movie)
end
