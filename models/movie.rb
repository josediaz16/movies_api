require './db/init'
require_relative 'show_day'

class Movie < Sequel::Model(DB[:movies])
  many_to_many :show_days
  one_to_many  :reservations
  plugin :validation_helpers

  def validate
    super
    validates_unique :name
  end

  def self.by_show_day(show_day)
    self
      .association_join(:show_days)
      .where(day_number: show_day)
      .select_all(:movies)
      .to_a
  end
end
