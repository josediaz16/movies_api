require './services/movies/create'
require './models/movie'

RSpec.describe Movies::Create do
  let(:subject) { described_class.new }

  let(:result) { subject.(input) }

  let(:input) do
    {
      name: 'Back to the future',
      description: 'Marty Mcfly is sent back to 1955 and he has to save Doc Emmet Brown',
      image_url: 'https://myimages.com/back_to_the_future'
    }
  end

  describe "#call" do
    context "The input is valid" do
      it "Should be success" do
        expect(result).to be_success
        expect(Movie.count).to eq(1)

        movie = Movie.last
        expect(movie.name).to eq(input[:name])
        expect(movie.description).to eq(input[:description])
        expect(movie.image_url).to eq(input[:image_url])
      end
    end

    context "The name is taken" do
      it "Should be failure" do
        Movie.create(input)

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

        movie = Movie.last
        expect(movie.name).to eq(input[:name])
        expect(movie.description).to eq(input[:description])
        expect(movie.image_url).to eq(input[:image_url])
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
        ])
        expect(Movie.count).to eq(0)
      end
    end
  end
end
