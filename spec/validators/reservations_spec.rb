require './validators/reservations'
require './models/show_day'
require './services/movies/create'

RSpec.describe Validators::Reservations do
  let(:result) { described_class.(input) }

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
      end
    end

    context "The movie is not available that day" do
      it "Should be failure" do
        input[:reservation_date] = Date.new(2019, 10, 3)

        expect(result).to be_failure
        expect(result.messages).to eq(
          available_movie: ["invalid~The movie is not available this day"]
        )
      end
    end

    context "The reservation_count is bigger than 10" do
      it "Should be failure" do
        input[:reservation_count] = 11

        expect(result).to be_failure
        expect(result.messages).to eq(
          reservation_count: ["lteq~must be less than or equal to 10"]
        )
      end
    end

    context "There is not enough places left" do
      it "Should be failure" do
        Reservation.create(document: 1112211, movie_id: movie.id, reservation_count: 8, reservation_date: input[:reservation_date])

        expect(result).to be_failure
        expect(result.messages).to eq(
          max_reservations: ["invalid~There are not enough places left"]
        )
      end
    end

    context "There movie does not exist" do
      it "Should be failure" do
        input[:movie_id] = 1000000

        expect(result).to be_failure
        expect(result.messages).to eq(
          movie_id: ["existance~The record does not exist"]
        )
      end
    end

    context "The input is invalid" do
      let(:input) { {} }
      it "Should be failure" do
        expect(result).to be_failure
        expect(result.messages).to eq(
          document: ["blank~is missing"],
          movie_id: ["blank~is missing", "existance~The record does not exist"],
          reservation_count:  [
            "blank~is missing",
            "gt~must be greater than 0",
            "lteq~must be less than or equal to 10"
          ],
          reservation_date: ["blank~is missing"]
        )
      end
    end
  end
end
