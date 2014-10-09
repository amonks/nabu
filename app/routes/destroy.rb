

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
