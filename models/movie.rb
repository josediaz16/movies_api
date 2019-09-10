require './db/init'

class Movie < Sequel::Model(DB[:movies])
  many_to_many :show_days
  plugin :validation_helpers

  def validate
    super
    validates_unique :name
  end
end
