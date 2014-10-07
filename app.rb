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
  # Migrate DB up
  DB.create_table :data do
    DateTime :sampleTime
    String :table
    String :column
    Float :value
  end
end

# instantiate data object
data = DB[:data]

# prepare REPL
get '/pry' do
  binding.pry
end


# # # # # #
# R E A D #
# # # # # #

# json
get '/data/json' do
  data.all.to_json
end
get '/data/:table/json' do
  data.where(:table => params[:table]).all.to_json
end
get '/data/:table/:column/json' do
  data.where(:table => params[:table]).where(:column => params[:column]).all.to_json
end

# graph
get '/data/:table/graph' do
  @table = params[:table]
  @columns = []
  @data = data.where(:table => params[:table])
  distincts = @data.distinct(:column).all
  distincts.each do |distinct|
    @columns.push distinct[:column]
  end
  @max = @data.max(:value)
  @min = @data.min(:value)
  @start = @data.min(:sampleTime)
  @end = @data.max(:sampleTime)

  slim :graph
end
get '/data/:table/:column/graph' do
  @table = params[:table]
  @column = params[:column]

  slim :graphCol
end


# # # # # # # #
# C R E A T E #
# # # # # # # #

get '/data/:table/add/*' do
  # instantiate output array
  additions = []

  # get data from url
  things = params[:splat].first.split('/')

  # common variables for all new datapoints
  @sampleTime = Time.now
  @table = params[:table]

  # iterate through individual datapoints
  things.each do |thing|
    @column = thing.split(':')[0]
    @value = thing.split(':')[1]
    addition = {
      :sampleTime => @sampleTime,
      :table => @table,
      :column => @column,
      :value => @value
    }
    data.insert(addition)
    additions.push(addition)
  end

  # show output
  additions.to_json
end



# # # # # # # # #
# D E S T R O Y #
# # # # # # # # #

get '/data/flush' do
  data.all.delete
end
get '/data/:table/flush' do
  data.where(:table => params[:table]).all.delete
end
