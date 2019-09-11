require './app'
require './spec/spec_helper'
require './models/show_day'
require './services/movies/create'

RSpec.describe App do
  describe "GET /reservations" do
    context "No dates provided" do
      it "should return 400" do
        get '/reservations'

        expect(last_response.status).to eq(400)
      end
    end

    context "dates provided" do
      before do
        days = {'monday' => 1, 'tuesday' => 2, 'wednesday' => 3, 'thursday' => 4, 'friday' => 5, 'saturday' => 6, 'sunday' => 7}

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

      let!(:reservation_1) { Reservation.create(reservation_date: Date.new(2019, 10, 2), movie_id: movie_1.id, reservation_count: 3, document: "123") }
      let!(:reservation_2) { Reservation.create(reservation_date: Date.new(2019, 10, 8), movie_id: movie_1.id, reservation_count: 5, document: "456") }
      let!(:reservation_3) { Reservation.create(reservation_date: Date.new(2019, 10, 5), movie_id: movie_2.id, reservation_count: 3, document: "123") }
      let!(:reservation_4) { Reservation.create(reservation_date: Date.new(2019, 10, 3), movie_id: movie_3.id, reservation_count: 2, document: "456") }

      context "There are reservations for the dates provided" do
        let(:params) do
          {
            start_date: Date.new(2019, 10, 1),
            end_date: Date.new(2019, 10, 9),
          }
        end

        it "Should return an array of reservations" do
          get '/reservations', params

          expect(last_response).to be_ok
          expect(json_response.count).to eq(4)
          expect(json_response).to match_array([
            {
              "id"=>reservation_2.id,
              "movie"=> {
                "id"=>movie_1.id,
                "description"=>"Cool movie",
                "image_url"=>"https://image.com/image.jpg"
              },
              "reservation_count"=>5,
              "reservation_date"=>"2019-10-08"
            },
            {
              "id"=>reservation_1.id,
              "movie"=> {
                "id"=>movie_1.id,
                "description"=>"Cool movie",
                "image_url"=>"https://image.com/image.jpg"
              },
              "reservation_count"=>3,
              "reservation_date"=>"2019-10-02"
            },
            {
              "id"=>reservation_3.id,
              "movie"=> {
                "id"=>movie_2.id,
                "description"=>"Aliens!",
                "image_url"=>"https://image.com/image.jpg"
              },
             "reservation_count"=>3,
             "reservation_date"=>"2019-10-05"
            },
            {
              "id"=>reservation_4.id,
              "movie"=> {
                "id"=>movie_3.id,
                "description"=>"Mr miyagi",
                "image_url"=>"https://image.com/image.jpg"
              },
              "reservation_count"=>2,
              "reservation_date"=>"2019-10-03"
            }
          ])
        end
      end

      context "There are no reservations for the dates provided" do
        let(:params) do
          {
            start_date: Date.new(2019, 10, 6),
            end_date: Date.new(2019, 10, 7),
          }
        end

        it "Should return an empty array" do
          get '/reservations', params

          expect(last_response).to be_ok
          expect(json_response.count).to eq(0)
        end
      end
    end
  end
end
