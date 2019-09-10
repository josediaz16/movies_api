require './services/reservations/create'
require './services/movies/create'
require './models/reservation'
require './models/show_day'

RSpec.describe Reservations::Create do
  let(:subject) { described_class.new }

  let(:result) { subject.(input) }

  before do
    days = {'monday' => 1, 'tuesday' => 2, 'wednesday' => 3, 'thursday' => 4, 'friday' => 5, 'saturday' => 6, 'sunday' => 7}

    days.each do |name, day_number|
      ShowDay.create(day_number: day_number, name: name)
    end
  end

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

  describe "#call" do
    context "The input is valid" do
      it "Should be success" do
        expect(result).to be_success
        expect(Reservation.count).to eq(1)

        reservation = Reservation.last
        expect(reservation.movie_id).to eq(movie.id)
        expect(reservation.document).to eq(input[:document])
        expect(reservation.reservation_date).to eq(input[:reservation_date])
        expect(reservation.reservation_count).to eq(input[:reservation_count])
      end
    end

    context "The movie is not available that day" do
      it "Should be failure" do
        input[:reservation_date] = Date.new(2019, 10, 3)

        expect(result).to be_failure
        expect(result.failure[:errors]).to match_array([
          {
            object_class: "reservation",
            field: "available_movie",
            code: "invalid",
            description: "The movie is not available this day",
            value: nil,
            extra: {}
          }
        ])
      end
    end

    context "The reservation_count is bigger than 10" do
      it "Should be failure" do
        input[:reservation_count] = 11

        expect(result).to be_failure
        expect(result.failure[:errors]).to match_array([
          {
            object_class: "reservation",
            field: "reservation_count",
            code: "lteq",
            description: "must be less than or equal to 10",
            value: 11,
            extra: {}
          }
        ])
      end
    end

    context "There is not enough places left" do
      it "Should be failure" do
        Reservation.create(document: 1112211, movie_id: movie.id, reservation_count: 8, reservation_date: input[:reservation_date])

        expect(result).to be_failure
        expect(result.failure[:errors]).to match_array([
          {
            object_class: "reservation",
            field: "max_reservations",
            code: "invalid",
            description: "There are not enough places left",
            value: nil,
            extra: {}
          }
        ])
      end
    end
  end
end
