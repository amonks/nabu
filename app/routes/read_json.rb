get '/data/json' do
  # instantiate data object
  data = DB[:data]

  data.order(:sampleTime).all.to_json
end
get '/data/:table/json' do
  # instantiate data object
  data = DB[:data]

  data.where(:table => params[:table]).order(:sampleTime).all.to_json
end
get '/data/:table/:column/json' do
  # instantiate data object
  data = DB[:data]

  data.where(:table => params[:table]).where(:column => params[:column]).order(:sampleTime).all.to_json
end
