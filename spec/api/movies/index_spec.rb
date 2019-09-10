require './app'
require './spec/spec_helper'
require './models/show_day'
require './services/movies/create'

RSpec.describe App do
  describe "GET /movies" do
    context "No show_day provided" do
      it "should return 400" do
        get '/movies'

        expect(last_response.status).to eq(400)
      end
    end

    context "show_day provided" do
      before do
        days = {'sunday' => 1, 'monday' => 2, 'tuesday' => 3, 'wednesday' => 4, 'thursday' => 5, 'friday' => 6, 'saturday' => 7}

        days.each do |name, day_number|
          ShowDay.create(day_number: day_number, name: name)
        end
      end

      let!(:movie_1) do
        Movies::Create
          .new.(name: 'Back to the future', description: 'Cool movie', show_days: [1, 2], image_url: 'https://image.com/image.jpg')
          .success[:model]
      end
      let!(:movie_2) do
        Movies::Create
          .new.(name: 'Men in black', description: 'Aliens!', show_days: [2, 5, 7], image_url: 'https://image.com/image.jpg')
          .success[:model]
      end

      let!(:movie_3) do
        Movies::Create
          .new.(name: 'Karate kid', description: 'Mr miyagi', show_days: [1, 3, 5], image_url: 'https://image.com/image.jpg')
          .success[:model]
      end

      context "There are movies for the day provided" do
        it "should return 200 with an array of movies" do
          get '/movies', show_day: 2

          expect(last_response).to be_ok
          expect(json_response.count).to eq(2)
          expect(json_response).to match_array([
            {
              "id"=>movie_1.id,
              "description"=>"Cool movie",
              "image_url"=>"https://image.com/image.jpg"
            },
            {
              "id"=>movie_2.id,
              "description"=>"Aliens!",
              "image_url"=>"https://image.com/image.jpg"
            }
          ])
        end
      end

      context "There are no movies for the day provided" do
        it "should return 200 with an array of movies" do
          get '/movies', show_day: 6

          expect(last_response).to be_ok
          expect(json_response.count).to eq(0)
        end
      end
    end
  end
end
