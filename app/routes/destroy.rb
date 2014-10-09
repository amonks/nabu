

# delete all
get '/data/flush' do
  # instantiate data object
  data = DB[:data]

  data.delete

  redirect '/'
end

# delete one table
get '/data/:table/flush' do
  # instantiate data object
  data = DB[:data]

  data.where(:table => params[:table]).delete

  redirect '/'
end

# delete one column from one table

get '/data/:table/:column/flush' do
  # instantiate data object
  data = DB[:data]

  data.where(:table => params[:table], :column => params[:column]).delete

  redirect "/data/#{params[:table]}/graph"
end
