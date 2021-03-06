function graphIt(table, columns, min, max, start, end) {

  // common margins
  var margin = {
    top: 50,
    right: 50,
    bottom: 30,
    left: 50
  };


  d3.select("#graph")
    .append("h2")
    .text(table);

  var width = parseInt(d3.select("#graph").style("width")) - margin.left - margin.right;
  var height = 300;

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
  var svg = d3.select("#graph").append("svg:svg")
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

  // graph max and min
  var minIndex = columns.indexOf("min");
  var maxIndex = columns.indexOf("max");
  if (minIndex !== -1 && maxIndex !== -1) {
    d3.json("/data/" + table + "/max/json", graphMaxMin);
    columns.splice(columns.indexOf("min"), 1);
    columns.splice(columns.indexOf("max"), 1);
  }

  // graph other columns
  for (var column in columns) {
    d3.json("/data/" + table + "/" + columns[column] + "/json", graphLine);
  }


  //
  // functions
  //

  function randomColor() {
    return d3.hsl(Math.floor(Math.random() * 360), Math.random(), 0.8).toString();
  }

  function graphMaxMin(error, json) {
    var color = randomColor();
    graphArea(error, json, color);
    d3.json("/data/" + table + "/min/json", graphMin);

    function graphMin(error, json) {
      graphArea(error, json, "white");
    }
  }

  function graphArea(error, dataSet, color) {
    var area = createArea(error, dataSet);
    // draw line
    svg.append("path")
      .datum(dataSet)
      .attr("class", "area")
      .attr("d", area)
      .style("fill", color);

    function createArea(error, dataSet) {
      if (error) return console.warn(error);

      // create area
      return d3.svg.area()
        .x(function(d) {
          return x(timeFn(d));
        })
        .y0(height)
        .y1(function(d) {
          return y(valueFn(d));
        });
    }
  }

  function graphLine(error, dataSet) {
    var line = createLine(error, dataSet);

    var color = randomColor();

    // draw line
    svg.append("path")
      .datum(dataSet)
      .attr("class", "line")
      .attr("d", line)
      .style("stroke", color)
      .attr("data-legend", function(d) {
        return d[0].column;
      });
    // draw legend
    svg.append("g")
      .attr("class", "legend")
      .attr("transform", "translate(50,30)")
      .style("font-size", "20px")
      .attr("data-style-padding", 10)
      .attr("data-legend-color", "red")
      .call(d3.legend);

    function createLine(error, dataSet) {
      if (error) return console.warn(error);

      // create line
      return d3.svg.line()
        .x(function(d) {
          return x(timeFn(d));
        })
        .y(function(d) {
          return y(valueFn(d));
        });
    }
  }
};
