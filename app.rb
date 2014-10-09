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

# connect to DB
DB = Sequel.connect('postgres://localhost/nabu')

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
  redirect '/data/graph'
end

get '/info' do
  slim :info
end
