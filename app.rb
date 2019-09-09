require 'sinatra'
require './services/movies/create'

class App < Sinatra::Base
  before do
    content_type :json
  end

  get '/' do
    {hello: 'world'}.to_json
  end

  post '/movies' do
    input = params.slice(:name, :description, :image_url)
    result = Movies::Create.new.(input)

    if result.success?
      status 200
      result.success[:model].values.to_json
    else
      status 400
      result.failure.to_json
    end
  end
end
