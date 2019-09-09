require 'sequel'

DB = Sequel.connect('postgres://postgres@postgres:5432/movies_db')
Sequel::Model.plugin :timestamps, update_on_create: true
