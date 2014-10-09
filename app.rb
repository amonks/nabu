# # # # # # # # # #
#   ~ N A B U ~   #
#                 #
# by:             #
#   Andrew Monks  #
# github:         #
#   amonks/nabu   #
# # # # # # # # # #

# Load Dependencies
require 'bundler'
Bundler.require
require 'json'

if ENV['RACK_ENV'] != 'production'
  Dotenv.load
end

# connect to DB
DB = Sequel.connect(ENV['DATABASE_URL'])

require_relative 'app/helpers'
require_relative 'app/routes'

# migrate db
get '/migrate' do
  migrateDatabase(DB)
end

# prepare REPL
get '/pry' do
  binding.pry
end

get '/' do
  redirect '/info'
end

get '/info' do
  slim :info
end
