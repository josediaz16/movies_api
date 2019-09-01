require 'sinatra'

class App < Sinatra::Base
  before do
    content_type :json
  end

  get '/' do
    {hello: 'world'}.to_json
  end
end
