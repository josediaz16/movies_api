namespace :db do
  desc "Run migrations"

  task :migrate, [:version, :env] do |t, args|
    require 'sequel/core'
    require 'yaml'

    Sequel.extension :migration
    version = args[:version].to_i if args[:version]

    env = ENV["RACK_ENV"] || "development"
    config = YAML.load_file('./config/database.yml')
    url = config.fetch(env)

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
    db_name = config.fetch(env).match(/\/([^\/]+)$/)[1]

    Sequel.connect('postgres://postgres@postgres:5432/postgres') do |db|
      db.execute "DROP DATABASE IF EXISTS #{db_name}"
      db.execute "CREATE DATABASE #{db_name}"
    end
  end
end
