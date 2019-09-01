namespace :db do
  desc "Run migrations"

  task :migrate, [:version] do |t, args|
    require 'sequel/core'
    Sequel.extension :migration
    version = args[:version].to_if if args[:version]
    Sequel.connect('postgres://postgres@postgres:5432/movies_db') do |db|
      Sequel::Migrator.run(db, "db/migrate", target: version)
    end
  end

  task :create do
    require 'sequel'
    Sequel.connect('postgres://postgres@postgres:5432/postgres') do |db|
      db.execute "DROP DATABASE IF EXISTS movies_db"
      db.execute "CREATE DATABASE movies_db"
    end
  end
end
