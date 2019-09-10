require 'blueprinter'

class MovieBlueprint < Blueprinter::Base
  identifier :id
  fields :description, :image_url
end
