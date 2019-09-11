require './db/init'

class Reservation < Sequel::Model(DB[:reservations])
  many_to_one :movie

  def self.between_dates(start_date, end_date)
    self
      .association_join(:movie)
      .where(reservation_date: start_date...end_date)
      .select_all(:reservations)
      .to_a
  end
end
