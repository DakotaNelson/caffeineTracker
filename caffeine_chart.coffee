class caffeineChart
  renderGraph: (full_width,full_height) ->
    doses = 0
    data = @caffeineModel(doses)

    times = []
    _.each(data, (e) ->
      times.push(e[0]))

    alldata = []
    _.each(data, (e) ->
      alldata.push(e[1])
      alldata.push(e[2]))

    margin = {top:20, bottom: 40, left:10, right:20}
    width = full_width - margin.left - margin.right
    height = full_height - margin.top - margin.bottom

    outer_wrap = d3.select("#graph-container")
                   .attr("width",full_width)
                   .attr("height",full_height)

    inner_wrap = outer_wrap.append("g")
                           .attr("transform","translate(#{margin.left},#{margin.top})")

    #x = d3.time.scale()
    x = d3.scale.linear()
               .domain([_.min(times),_.max(times)])
               .range([0,width])

    y = d3.scale.linear()
                .domain([0,_.max(alldata)])
                .range([height,0])

    xAxis = d3.svg.axis()
                  .scale(x)
                  .orient('bottom')
                  .ticks()

    yAxis = d3.svg.axis()
                  .scale(y)
                  .orient('left')

    #xAxis_handle = inner_wrap.append("g")
              #.attr("class","axis")
              #.attr("transform","translate(0," + height + ")")
              #.call(xAxis)

    line_function = d3.svg.line()
                    .x( (d) -> return x(d[0]) )
                    .y( (d) -> return y(d[1]) )
                    #.interpolate("linear")

    data_line = inner_wrap.append("g")
                          .append("path")
                          .datum(data)
                          .attr("class","line")
                          .attr("fill","none")
                          .attr("stroke","black")
                          .attr("d",line_function(data))

    console.log(data)

    data_points = inner_wrap.append('g').selectAll('circle')
                             .data(data)
                             .enter()
                             .append("circle")
                             .attr("cx", (d) -> x(d[0]))
                             .attr("cy", (d) -> y(d[1]))
                             .attr("r",4)

  caffeineModel: (doses) =>
    # Doses: array of tuples.
    #   [0] -> Time of dose
    #   [1] -> Dosage in mg
    #
    # Returns an array of triples:
    # [[timestamp,blood_concentration,unabsorbed_concentration],[etc],[etc]]

    maxiters = 2000 # max iterations of the ODE solver
    endt = 4 * 60 * 60 # end time, in seconds

    init_b = 1
    init_c = 100

    caffeineSystem = (t,concs) ->
      tau = 1/5
      a = 1
      b_conc = concs[0] # blood concentration
      c_conc = concs[1] # unabsorbed caffeine concentration
      return [(a*c_conc - tau*b_conc),(-a*c_conc)]
      # dB/dt = a*C - tau*B
      # dC/dt = -a*C

    sol = numeric.dopri(0,endt,[init_b,init_c],caffeineSystem,1e-6,maxiters)

    times = _.range(0,endt,endt/20) # create 20 time values
    concentrations = sol.at(times) # grab concentrations for each time
    retdata = []
    _.each(times, (e,i) ->
      retdata.push([e,concentrations[i][0],concentrations[i][1]]))
    return retdata

###############################################################################
$( document ).ready( ->
  full_width = $( window ).width()
  full_height = $( window ).height()
  chart = new caffeineChart
  chart.renderGraph(full_width,full_height)
  return)

