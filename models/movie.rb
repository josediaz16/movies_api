require './db/init'

class Movie < Sequel::Model(DB[:movies])
end
