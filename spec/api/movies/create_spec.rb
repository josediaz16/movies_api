require './app'
require './spec/spec_helper'

RSpec.describe App do
  let(:input) do
    {
      name: 'Back to the future',
      description: 'Marty Mcfly is sent back to 1955 and he has to save Doc Emmet Brown',
      image_url: 'https://myimages.com/back_to_the_future'
    }
  end

  describe "POST /movies" do
    context "The params are valid" do
      it "Should create a new movie" do
        post '/movies', input

        expect(last_response).to be_ok

        expect(Movie.count).to eq(1)

        movie = Movie.last
        expect(json_response["id"]).to eq(movie.id)

        expect(movie.name).to eq(input[:name])
        expect(movie.description).to eq(input[:description])
        expect(movie.image_url).to eq(input[:image_url])
      end
    end

    context "The params are not valid" do
      it "Should create a new movie" do
        post '/movies', {}

        expect(last_response).not_to be_ok
        expect(last_response.status).to eq(400)

        expect(Movie.count).to eq(0)
        expect(json_response).to eq(
          "errors"=> [
            {
              "object_class"=>"movie",
              "field"=>"name",
              "code"=>"blank",
              "description"=>"is missing",
              "value"=>nil,
              "extra"=>{}
            },
            {
              "object_class"=>"movie",
              "field"=>"description",
              "code"=>"blank",
              "description"=>"is missing",
              "value"=>nil,
              "extra"=>{}
            },
            {"object_class"=>"movie",
              "field"=>"image_url",
              "code"=>"blank",
              "description"=>"is missing",
              "value"=>nil,
              "extra"=>{}
            }
          ]
        )
      end
    end
  end
end
