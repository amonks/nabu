require 'dotenv'
require 'sequel'
require 'pg'


if ENV['RACK_ENV'] != 'production'
  Dotenv.load
end

# connect to DB
DB = Sequel.connect(ENV['DATABASE_URL'])

require_relative '../app/helpers/database'

migrateDatabase(DB)
