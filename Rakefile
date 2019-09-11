namespace :db do
  desc "Run migrations"

  task :migrate, [:version, :env] do |t, args|
    require 'sequel/core'
    require 'yaml'

    Sequel.extension :migration
    version = args[:version].to_i if args[:version]

    url = ENV["DATABASE_URL"] || -> do
      env = ENV["RACK_ENV"] || "development"
      config = YAML.load_file('./config/database.yml')
      config.fetch(env)
    end.()

    Sequel.connect(url) do |db|
      Sequel::Migrator.run(db, "db/migrate", target: version)
    end
  end

  task :test_prepare do
    system("RACK_ENV=test rake db:create")
    system("RACK_ENV=test rake db:migrate")
  end

  task :create do
    require 'sequel'
    require 'yaml'

    env = ENV["RACK_ENV"] || "development"
    config = YAML.load_file('./config/database.yml')

    url = ENV["DATABASE_URL"] || -> do
      env = ENV["RACK_ENV"] || "development"
      config = YAML.load_file('./config/database.yml')
      config.fetch(env)
    end.()

    db_name = url.match(/\/([^\/]+)$/)[1]

    Sequel.connect('postgres://postgres@postgres:5432/postgres') do |db|
      db.execute "DROP DATABASE IF EXISTS #{db_name}"
      db.execute "CREATE DATABASE #{db_name}"
    end
  end

  task :seed do
    require './models/show_day'

    days = {'monday' => 1, 'tuesday' => 2, 'wednesday' => 3, 'thursday' => 4, 'friday' => 5, 'saturday' => 6, 'sunday' => 7}

    days.each do |name, day_number|
      ShowDay.create(day_number: day_number, name: name)
    end
  end
end
