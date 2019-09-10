require './app'
require './spec/spec_helper'
require './models/show_day'

RSpec.describe App do
  let(:movie) do
    Movies::Create
      .new.(name: 'Back to the future', description: 'Cool movie', show_days: [1, 3], image_url: 'https://image.com/image.jpg')
      .success[:model]
  end

  let(:input) do
    {
      movie_id: movie.id,
      reservation_date: Date.new(2019, 10, 2),
      reservation_count: 3,
      document: "123456"
    }
  end

  before do
    days = {'monday' => 1, 'tuesday' => 2, 'wednesday' => 3, 'thursday' => 4, 'friday' => 5, 'saturday' => 6, 'sunday' => 7}

    days.each do |name, day_number|
      ShowDay.create(day_number: day_number, name: name)
    end
  end

  describe "POST /movies" do
    context "The params are valid" do
      it "Should create a new reservation for a movie" do
        post "/movies/#{movie.id}/reservations", input
        expect(last_response).to be_ok

        expect(Reservation.count).to eq(1)

        reservation = Reservation.last
        expect(json_response["id"]).to eq(reservation.id)

        expect(reservation.movie_id).to eq(movie.id)
        expect(reservation.document).to eq(input[:document])
        expect(reservation.reservation_date).to eq(input[:reservation_date])
        expect(reservation.reservation_count).to eq(input[:reservation_count])
      end
    end

    context "The movie is not available that day" do
      it "Should be 400" do
        input[:reservation_date] = Date.new(2019, 10, 3)

        post "/movies/#{movie.id}/reservations", input

        expect(last_response.status).to eq(400)
        expect(json_response).to eq(
          "errors" => [
            {
              "object_class" => "reservation",
              "field" => "available_movie",
              "code" => "invalid",
              "description" => "The movie is not available this day",
              "value" => nil,
              "extra" => {}
            }
          ]
        )
      end
    end

    context "There is not enough places left" do
      it "Should be 400" do
        Reservation.create(document: 1112211, movie_id: movie.id, reservation_count: 8, reservation_date: input[:reservation_date])

        post "/movies/#{movie.id}/reservations", input

        expect(last_response.status).to eq(400)
        expect(json_response).to eq(
          "errors" => [
            {
              "object_class" => "reservation",
              "field" => "max_reservations",
              "code" => "invalid",
              "description" => "There are not enough places left",
              "value" => nil,
              "extra" => {}
            }
          ]
        )
      end
    end

    context "There movie does not exist" do
      it "Should be 400" do
        post "/movies/100000/reservations", input

        expect(last_response.status).to eq(400)
        expect(json_response).to eq(
          "errors"=> [
            {
              "object_class"=>"reservation",
              "field"=>"movie_id",
              "code"=>"existance",
              "description"=>"The record does not exist",
              "value"=>"100000",
              "extra"=>{}
            }
          ]
        )
      end
    end
  end
end
