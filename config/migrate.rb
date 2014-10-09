require 'bundler'
Bundler.require


if ENV['RACK_ENV'] != 'production'
  Dotenv.load
end

# connect to DB
DB = Sequel.connect(ENV['DATABASE_URL'])

require_relative '../app/helpers/database'

migrateDatabase(DB)
