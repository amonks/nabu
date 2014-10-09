# # # # # # # # # # # # #
# E N V I R O N M E N T #
# # # # # # # # # # # # #

# Load Dependencies
require 'bundler'
Bundler.require
require 'json'

# connect to DB
DB = Sequel.connect('postgres://localhost/nabu')

require_relative 'app/helpers'
require_relative 'app/routes'

# migrate db
# visit this after creating a psql db
get '/migrate' do
  migrateDatabase(DB)
end

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
