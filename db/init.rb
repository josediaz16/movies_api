require 'sequel'
require 'yaml'

url = ENV["DATABASE_URL"] || -> do
  config = YAML.load_file('./config/database.yml')
  config.fetch(ENV["RACK_ENV"] || "development")
end.()

DB = Sequel.connect(url)
Sequel::Model.plugin :timestamps, update_on_create: true
