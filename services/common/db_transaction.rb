require './db/init'

module Common
  module DbTransaction

    def call(input)
      response = nil
      DB.transaction do
        response = super(input)
      end
      response
    end
  end
end
