// set the dimensions of the canvas
var dim = {width: 960, height: 800};
var margin = {top: 10, bottom: 50, left: 50, right: 10};
var inputHeight = 20;
var numberFormat = d3.format('.0f');
dim.graphWidth = dim.width - margin.left - margin.right;
dim.graphHeight = dim.height - margin.top - margin.bottom;

// add the SVG element
var svg = d3.select('div#howdy').append('svg')
  .attr({width: dim.width, height: dim.height})
  .style({margin:0,padding:0});

// tool tip
var tip = d3.tip()
  .attr('class', 'd3-tip')
  .offset([-10, 0])
  .html(function(d) {
    // return `${d[0].content}`;
    let date = new Date(d[0].date)
    // let month = date.toLocaleString('en-us', { month: "long" })
    // let day = date.getDate()

    return `
    <div class="g-tweet">
      <div class="container">
        <div class='row'>
          <img class="col-xs-1 g-trump-mug" src="https://static01.nyt.com/newsgraphics/2017/04/18/tweet-trump-timeline/dec2b81d4047d1ed02e8a139533274463c05970c/trump_mug.jpg" alt="">
          <div class="col-xs-8 g-user-details">
            <div class="g-username">Donald J. Trump <img class="g-verified" src="https://static01.nyt.com/newsgraphics/2017/04/18/tweet-trump-timeline/dec2b81d4047d1ed02e8a139533274463c05970c/verified.png" alt=""></div>
            <div class="g-handle">@realDonaldTrump</div>
          </div>
          <span class="g-tweet-text col-xs-12">${d[0].content}</span>
          <span class="g-time col-xs-12">${date}</span>
        </div>
      </div>
    </div>
    `
  })
svg.call(tip);

// add axis
var axisLayer = svg.append('g').attr('transform','translate(' + margin.left + ',' + margin.top + ')');
var graphLayer = svg.append('g').attr('transform','translate(' + margin.left + ',' + margin.top + ')');
var inputLayer = svg.append('g').attr('transform','translate(0,' + (dim.height - inputHeight) + ')');

// set the ranges
var xScale = d3.scale.ordinal().rangeBands([0,dim.graphWidth],0.05);
var xLocalScale = d3.scale.ordinal();
var yScale = d3.scale.ordinal().rangePoints([dim.graphHeight, 0]);
var colorScale = d3.scale.category10();
var inputScale = d3.scale.ordinal().rangeBands([0,dim.width-margin.right]);

// define the axis
var xAxis = d3.svg.axis().orient('bottom').scale(xScale);
var yAxis = d3.svg.axis().orient('left').scale(yScale);

//what is this axisLayer stuff?
var xAxisObj = axisLayer.append('g')
  .attr('transform','translate('+0+','+dim.graphHeight+')')
  .attr('class','axis')
  .call(xAxis);
var yAxisObj = axisLayer.append('g')
  .attr('transform','translate('+0 +','+0+')')
  .attr('class','axis')
  .call(yAxis)


axisLayer.selectAll('.axis text').style('font','10px "Lucida Grande", Helvetica, Arial, sans-serif');
axisLayer.selectAll('.axis path.domain').style({fill:'none',stroke:'#000000','shape-rendering':'auto'});
axisLayer.selectAll('.axis line').style({fill:'none',stroke:'#000000','shape-rendering':'auto'});

var time = 0;
var yearLabel = 'year';
var radius = 3.5;
var mar = 0.6;
var years = [];

// load the data
d3.json('circle.json', function(error,raw){
  if (error != null){
    console.log(error);
    return;
  }

  // structuring data
    // grab year values ie [0,1,2,3,4,5]
    years = d3.set(raw.map(function(d){return d[yearLabel];})).values();
    yearTarget = years[0];
    // grab letters ie [A,B,C,D,E]
    var parties = d3.keys(raw[0]).filter(function(d){return d !== yearLabel;});
    var partDict = {};
    // iterate over x values to format an object. why?
    parties.forEach(function(d,i){
      partDict[d] = i;
    });
    // iterate over values to make data object with key of year and value of party
    // {0: Array(7), 1: Array(7), 2: Array(7), 3: Array(7), 4: Array(7), 5: Array(7)}
    // array has 7 data points for that year eg {0: [2,150,0,144,48,410,803]}
    var sums = {};
    var data = {};
    years.forEach(function(year){
      data[year] = parties.map(function(party){
        return +raw.filter( d => d[yearLabel] === year )
        [0][party].length || 0;
      });
      // add all the values by year
      // {0: 1557, 1: 1594, 2: 1584, 3: 1482, 4: 1627, 5: 1680}
      sums[year] = d3.sum(data[year]);
    });

  // setting domain
    // highest single data point ie 882
    var max = d3.max(years.map(function(d){return d3.max(data[d]);}));
    // number of vertical rows/height of dots
    var nrow = 100//Math.ceil(dim.graphHeight/(2*(radius+mar)));
    // how wide should each bar be eg 15 dots
    barWidth = 1//Math.ceil(max/nrow);
    // set graph characteristics based on above
    yScale.domain(d3.range(nrow));
      //tick labels for y axis
    yAxis.tickValues(d3.range(nrow).filter(function(d){return d%10===0;}));
    yAxis.tickFormat(function(d){return (d*barWidth);});
    // domain([0,1,2,3,4,5,6] sets the 6 columns
    xScale.domain(parties.map(function(d,i){return i;}));
    // display years "A" "B" "C"...
    xAxis.tickFormat(function(d){return parties[d];});
      // not sure but if you remove you lose tickmarks and value of ticks
    xAxisObj.call(xAxis)
      .selectAll("text")
        .style("text-anchor", "end")
        .attr("dx", "-.8em")
        .attr("dy", "-.55em")
        .attr("transform", "rotate(-90)" ); // turn the label on their side
    yAxisObj.call(yAxis).append('text').text("Tweets Per Week");


    xLocalScale.rangeBands([0,xScale.rangeBand()]).domain(d3.range(barWidth));
    colorScale.domain(d3.range(parties.length));

    inputScale.domain(years);


  var summax = d3.max(years.map(function(d){return sums[d];}));
  // this one looks pretty important
  var displaydata = d3.range(summax).map(function(d){return [];});
  var indexMargin = 0;

  // go through each party (graph)
  // display..
  for (var partyidx = 0; partyidx < parties.length; partyidx++) {
    let time_period = parties[partyidx]
    let tweets = raw[0][time_period]
    for (var i=0;i<data[years[0]][partyidx];++i){
      displaydata[indexMargin+i].push( {
        label: partyidx,
        idx: i,
        content: tweets[i].content,
        negative: tweets[i].negative,
        date: tweets[i].date
      } );
    }
    indexMargin += data[years[0]][partyidx];
  }

  for (var i=indexMargin;i<summax;++i){
    displaydata[i].push({label:null,idx:null});
  }

  // circles added to the dom
  var votes = graphLayer.selectAll('.vote').data(displaydata).enter().append('circle')
    .attr('class','vote')
    .attr('r',radius)
    .attr('cx',function(d){return ((d[time].label!=null)?(xScale(d[time].label)+xLocalScale(d[time].idx%barWidth)+radius+mar):(dim.graphWidth/2));})
    .attr('cy',function(d){return ((d[time].label!=null)?(yScale(Math.floor((d[time].idx+0.1)/barWidth))-radius-mar):0);})
    .on('mouseover', tip.show) // add tool tip to circle
    .on('mouseout', tip.hide)
    .style('opacity',function(d){return (d[time].label!=null)?0.8:0.0;})
    .style('fill', function (d) {
      if (d[0].negative) {
        return 'brown'
      } else {
        return 'steelblue'
      }
    });  // black dots without this
}); // end load the data

  // trying to make svg responsive
  var aspect = dim.width / dim.height,
  chart = d3.select('#chart');
  d3.select(window)
    .on("resize", function() {
      var targetWidth = chart.node().getBoundingClientRect().width;
      chart.attr("width", targetWidth);
      chart.attr("height", targetWidth / aspect);
  });
