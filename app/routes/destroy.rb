

# delete all
get '/data/flush' do
  # instantiate data object
  data = DB[:data]

  data.delete
end

# delete one table
get '/data/:table/flush' do
  # instantiate data object
  data = DB[:data]

  data.where(:table => params[:table]).delete
end

# delete one column from one table
  # instantiate data object
  data = DB[:data]

get '/data/:table/:column/flush' do
  data.where(:table => params[:table], :column => params[:column]).delete
end
