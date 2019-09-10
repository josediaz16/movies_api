require './validators/movies'

RSpec.describe Validators::Movies do
  let(:result) { described_class.(input) }

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
      it "Should be success" do
        expect(result).to be_success
      end
    end

    context "The input is valid" do
      let(:input) { {name: '', show_days: [10]} }

      it "Should be success" do
        expect(result).to be_failure
        expect(result.messages).to eq(
          name: ["blank~must be filled"],
          description: ["blank~is missing"],
          image_url: ["blank~is missing", "format~must be a valid url"],
          show_days: {0=>["inclusion~must be one of: 1, 2, 3, 4, 5, 6, 7"]}
        )
      end
    end
  end
end
