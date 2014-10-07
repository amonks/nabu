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

#
# json
#

get '/data/json' do
  data.order(:sampleTime).all.to_json
end
get '/data/:table/json' do
  data.where(:table => params[:table]).order(:sampleTime).all.to_json
end
get '/data/:table/:column/json' do
  data.where(:table => params[:table]).where(:column => params[:column]).order(:sampleTime).all.to_json
end

#
# graph
#

# helpers

# return a table object
def makeTable(name, data, columns)
  return {
    :table => name,
    :columns => columns,
    :max => data.max(:value),
    :min => data.min(:value),
    :start => data.min(:sampleTime),
    :end => data.max(:sampleTime),
  }
end

# return a table's distinct columns
def getColumns(table, data)
  columns = []
  dataset = data.where(:table => table)
  distincts = dataset.distinct(:column).all
  distincts.each do |distinct|
    columns.push distinct[:column]
  end
  return columns
end

# routes

# graph all
get '/data/graph' do
  tables = data.distinct(:table).all
  table_list = []
  tables.each do |table|
    table_list.push table[:table]
  end

  @tables = []
  table_list.each do |table|
    dataset = data.where(:table => table)
    columns = getColumns(table, data)

    @tables.push makeTable(table, dataset, columns)
  end

  slim :graph
end

# graph one table
get '/data/:table/graph' do
  table = params[:table]
  dataset = data.where(:table => table)
  columns = getColumns(table, data)

  @tables = []
  @tables.push makeTable(table, dataset, columns)

  slim :graph
end

# graph one column from one table
get '/data/:table/:column/graph' do
  table = params[:table]
  columns = [params[:column]]
  dataset = data.where(:table => table)

  @tables = []
  @tables.push makeTable(table, dataset, columns)

  slim :graph
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

# delete all
get '/data/flush' do
  data.delete
end

# delete one table
get '/data/:table/flush' do
  data.where(:table => params[:table]).delete
end

# delete one column from one table
get '/data/:table/:column/flush' do
  data.where(:table => params[:table], :column => params[:column]).delete
end
