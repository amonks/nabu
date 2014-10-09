# # # # # # # # # # # # #
# E N V I R O N M E N T #
# # # # # # # # # # # # #

# Load Dependencies
require 'bundler'
Bundler.require
require 'json'

# Set ENV
Dotenv.load

# connect to DB
DB = Sequel.connect('postgres://localhost/nabu')

unless ENV['MIGRATED'] == 'TRUE'
  migrateDatabase(DB)
end

require_relative 'app/helpers'
require_relative 'app/routes'

# prepare REPL
get '/pry' do
  binding.pry
end

get '/' do
  slim :index
end

get '/info' do
  slim :info
end
