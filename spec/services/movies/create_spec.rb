require './services/movies/create'
require './models/movie'
require './models/show_day'

RSpec.describe Movies::Create do
  let(:subject) { described_class.new }

  let(:result) { subject.(input) }

  let(:input) do
    {
      name: 'Back to the future',
      description: 'Marty Mcfly is sent back to 1955 and he has to save Doc Emmet Brown',
      image_url: 'https://myimages.com/back_to_the_future',
      show_days: [1, 2, 5]
    }
  end

  describe "#call" do
    context "The input is valid" do

      before do
        days = {'sunday' => 1, 'monday' => 2, 'tuesday' => 3, 'wednesday' => 4, 'thursday' => 5, 'friday' => 6, 'saturday' => 7}

        days.each do |name, day_number|
          ShowDay.create(day_number: day_number, name: name)
        end
      end

      it "Should be success" do
        expect(result).to be_success
        expect(Movie.count).to eq(1)

        movie = Movie.last
        expect(movie.name).to eq(input[:name])
        expect(movie.description).to eq(input[:description])
        expect(movie.image_url).to eq(input[:image_url])
        expect(movie.show_days.count).to eq(3)
        expect(movie.show_days.map(&:day_number)).to eq [1, 2, 5]
      end
    end

    context "The name is taken" do
      it "Should be failure" do
        Movie.create(input.except(:show_days))

        expect(result).to be_failure
        expect(result.failure[:errors]).to match_array([
          {
            object_class: "movie",
            field: "name",
            value: input[:name],
            code: "taken",
            description: "is already taken",
            extra: {}
          }
        ])

        expect(Movie.count).to eq(1)
      end
    end

    context "The show days are not valid" do
      it "Should be failure" do
        input[:show_days] = [10]

        expect(result).to be_failure
        expect(result.failure[:errors]).to match_array([
          {
            object_class: "movie",
            field: "show_days[0]",
            value: 10,
            code: "inclusion",
            description: "must be one of: 1, 2, 3, 4, 5, 6, 7",
            extra: {}
          }
        ])

        expect(Movie.count).to eq(0)

      end
    end


    context "The input is not valid" do
      let(:input) { {} }

      it "Should be failure" do
        expect(result).to be_failure
        expect(result.failure[:errors]).to match_array([
          {
            object_class: "movie",
            field: "name",
            value: nil,
            code: "blank",
            description: "is missing",
            extra: {}
          },
          {
            object_class: "movie",
            field: "description",
            value: nil,
            code: "blank",
            description: "is missing",
            extra: {}
          },
          {
            object_class: "movie",
            field: "image_url",
            value: nil,
            code: "blank",
            description: "is missing",
            extra: {}
          },
          {
            object_class: "movie",
            field: "show_days",
            value: nil,
            code: "blank",
            description: "is missing",
            extra: {}
          },
        ])
        expect(Movie.count).to eq(0)
      end
    end
  end
end
