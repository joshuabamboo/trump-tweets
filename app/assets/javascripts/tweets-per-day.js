document.addEventListener("DOMContentLoaded", function(e) {

  // set the dimensions of the canvas
  var margin = {top: 20, right: 20, bottom: 70, left: 40},
      width = 1500 - margin.left - margin.right,
      height = 750 - margin.top - margin.bottom;

  // set the ranges
  var x = d3.scale.ordinal().rangeRoundBands([0, width], .05);
  var y = d3.scale.linear().range([height, 0]);

  // define the axis
  var xAxis = d3.svg.axis()
  .scale(x)
  .orient("bottom")

  var yAxis = d3.svg.axis()
  .scale(y)
  .orient("left")
  .ticks(10);


  // tooltip
  var tip = d3.tip()
  .attr('class', 'd3-tip')
  .offset([315, 0])
  .html(function(d) {
    return `<strong>${d.Date}: </strong> <span style='color:red'> ${d.Count} tweets</span>`;
  })

  // add the SVG element
  var svg = d3.select("div#svg-container").append("svg")
      // .attr("width", width + margin.left + margin.right)
      // .attr("height", height + margin.top + margin.bottom)
      .attr("preserveAspectRatio", "xMinYMin meet")
      .attr("viewBox", "0 0 1450 800")
    .append("g")
      .attr("transform",
            "translate(" + margin.left + "," + margin.top + ")")
      .classed("svg-content", true);

  svg.call(tip);

  // load the data
  d3.json("data.json", function(error, data) {

      data.forEach(function(d) {
          d.Date = d.Date;
          d.Count = +d.Count;
      });

    // scale the range of the data
    x.domain(data.map(function(d) { return d.Date; }));
    y.domain([0, d3.max(data, function(d) { return d.Count; })]);

    // add axis
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis.tickValues(x.domain().filter((d, i) => !(i%7) )))
      .selectAll("text")
        .style("text-anchor", "end")
        .attr("dx", "-.8em")
        .attr("dy", "-.55em")
        .attr("transform", "rotate(-90)" );

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 5)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Tweets Per Day");

    // Add bar chart
    svg.selectAll("bar")
        .data(data)
      .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function(d) { return x(d.Date); })
        .attr("width", x.rangeBand())
        .attr("y", function(d) { return y(d.Count); })
        .attr("height", function(d) { return height - y(d.Count); })
        .on('mouseover', tip.show)
        .on('mouseout', tip.hide)
  });
});
