require './db/init'

class ShowDay < Sequel::Model(DB[:show_days])
end
