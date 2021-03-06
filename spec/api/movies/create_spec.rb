require './app'
require './spec/spec_helper'
require './models/show_day'

RSpec.describe App do
  let(:input) do
    {
      name: 'Back to the future',
      description: 'Marty Mcfly is sent back to 1955 and he has to save Doc Emmet Brown',
      image_url: 'https://myimages.com/back_to_the_future',
      show_days: [1, 2, 5]
    }
  end

  describe "POST /movies" do
    context "The params are valid" do

      before do
        days = {'sunday' => 1, 'monday' => 2, 'tuesday' => 3, 'wednesday' => 4, 'thursday' => 5, 'friday' => 6, 'saturday' => 7}

        days.each do |name, day_number|
          ShowDay.create(day_number: day_number, name: name)
        end
      end

      it "Should create a new movie" do
        post '/movies', input

        expect(last_response).to be_ok

        expect(Movie.count).to eq(1)

        movie = Movie.last
        expect(json_response["id"]).to eq(movie.id)

        expect(movie.name).to eq(input[:name])
        expect(movie.description).to eq(input[:description])
        expect(movie.image_url).to eq(input[:image_url])
        expect(movie.show_days.count).to eq(3)
        expect(movie.show_days.map(&:day_number)).to eq [1, 2, 5]
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
            },
            {"object_class"=>"movie",
              "field"=>"show_days",
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
