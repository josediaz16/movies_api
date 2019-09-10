require './db/init'

class ShowDay < Sequel::Model(DB[:show_days])
  many_to_many :movies
end
