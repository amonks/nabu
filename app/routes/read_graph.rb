# routes

# graph all
get '/data/graph' do
  # instantiate data object
  data = DB[:data]

  if table_list = getTables(data)
    @tables = []
    table_list.each do |table|
      dataset = data.where(:table => table)
      columns = getColumns(table, data)

      @tables.push makeTable(table, dataset, columns)
    end
    slim :graph
  else
    redirect '/info'
  end
end

# graph one table
get '/data/:table/graph' do
  # instantiate data object
  data = DB[:data]

  table = params[:table]
  dataset = data.where(:table => table)
  columns = getColumns(table, data)

  @tables = []
  @tables.push makeTable(table, dataset, columns)

  slim :graph
end

# graph one column from one table
get '/data/:table/:column/graph' do
  # instantiate data object
  data = DB[:data]

  table = params[:table]
  columns = [params[:column]]
  dataset = data.where(:table => table)

  @tables = []
  @tables.push makeTable(table, dataset, columns)

  slim :graph
end
