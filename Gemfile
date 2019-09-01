source 'https://rubygems.org'

ruby '2.6.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'sinatra'
gem 'shotgun'
gem 'dry-transaction'

group :test do
  gem 'rack-test', require: "rack/test"
  gem 'rspec'
end
