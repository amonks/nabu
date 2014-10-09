# database helpers

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

# return a list of tables
def getTables(data)
  tables = data.distinct(:table).all
  table_list = []
  tables.each do |table|
    table_list.push table[:table]
  end
  return (table_list.length == 0) ? nil : table_list
end

# migrate up
def migrateDatabase(db)
  # Migrate DB up
  db.create_table :data do
    DateTime :sampleTime
    String :table
    String :column
    Float :value
  end
end
