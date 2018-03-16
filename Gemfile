source 'https://rubygems.org'

git_source(:github) do |repo_name|
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.3'

gem 'rails', '~> 5.1.5'
gem 'pg'
gem 'pghero' #, git: 'https://github.com/ankane/pghero.git'
gem 'pg_query'
gem 'aws-sdk-cloudwatch'
gem 'puma'
gem 'activerecord-nulldb-adapter'
gem 'tzinfo-data'
gem 'sqlite3'
gem 'dotenv'

group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-ssh-doctor', require: false, github: 'pboling/capistrano-ssh-doctor', branch: 'fixed'
end
