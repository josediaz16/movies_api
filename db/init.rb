require 'sequel'
require 'yaml'

config = YAML.load_file('./config/database.yml')
url = config.fetch ENV["RACK_ENV"]

DB = Sequel.connect(url)
Sequel::Model.plugin :timestamps, update_on_create: true
