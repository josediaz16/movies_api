require 'dry-transaction'
require './services/common/crud'
require './validators/movies'
require './models/movie'

module Movies
  class Create
    include Dry::Transaction
    include Common::ApiResponse

    step :validate_input
    map  :parse_input
    step :persist
    tee  :save_show_days

    def validate_input(input)
      Common::Validate.new(Validators::Movies).(input)
    end

    def parse_input(input)
      {attributes: input.except("show_days", :show_days), original: input}
    end

    def persist(input)
      Common::Insert.new(Movie).(input)
    end

    def save_show_days(input)
      input[:original][:show_days].each do |show_day_number|
        show_day = ShowDay.where(day_number: show_day_number).last
        input[:model].add_show_day(show_day)
      end
    end
  end
end
