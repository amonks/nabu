var graphIt = function(table, min, max, start, end) {

  // common margins
  var margin = {
      top: 20,
      right: 20,
      bottom: 30,
      left: 50
    },
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

  // define ruby dateTime format
  var format = d3.time.format("%Y-%m-%d %H:%M:%S %Z");

  // x getter
  var timeFn = function(d) {
    return format.parse(d.sampleTime);
  };
  // y getter
  var valueFn = function(d) {
    return d.value;
  };

  // create x
  var x = d3.time.scale()
    .range([0, width])
    .domain([format.parse(start), format.parse(end)]);

  // create y
  var y = d3.scale.linear()
    .range([height, 0])
    .domain([min, max]);

  // create x axis
  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  // create y axis
  var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");

  // insert svg
  var svg = d3.select("body").append("svg:svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  // draw x axis
  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  // draw y axis
  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);

  // json callback
  for (column in columns) {

    d3.json("/data/" + table + "/" + columns[column] + "/json", function(error, json) {
      if (error) return console.warn(error);
      var dataSet = json;

      // create line
      var line = d3.svg.line()
        .x(function(d) {
          return x(timeFn(d));
        })
        .y(function(d) {
          return y(valueFn(d));
        });

      // draw line
      svg.append("path")
        .datum(dataSet)
        .attr("class", "line")
        .attr("d", line);
    });
  }
};
