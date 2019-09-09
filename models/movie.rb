require './db/init'

class Movie < Sequel::Model(DB[:movies])
  plugin :validation_helpers

  def validate
    super
    validates_unique :name
  end
end
