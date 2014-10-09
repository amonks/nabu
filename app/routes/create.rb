
get '/data/:table/add/*' do
  # instantiate data object
  data = DB[:data]

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

