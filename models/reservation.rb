require './db/init'

class Reservation < Sequel::Model(DB[:reservations])
  many_to_one :movie
end
