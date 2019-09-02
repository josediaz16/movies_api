require 'sequel'

DB = Sequel.connect('postgres://postgres@postgres:5432/movies_db')
