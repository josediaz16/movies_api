source 'https://rubygems.org'

ruby '2.6.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'sinatra'
gem 'shotgun'
gem 'dry-transaction'
gem 'dry-validation', '~> 0.13'
gem 'sequel'
gem 'irb', require: false
gem 'pg'
gem 'rake'
gem 'activesupport', require: false
gem 'blueprinter'

group :test do
  gem 'rack-test', require: "rack/test"
  gem 'rspec'
end
