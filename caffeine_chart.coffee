class caffeineChart
  renderGraph: (full_width,full_height) ->
    doses = [[0,0],[1,20],[3,10]]
    weight = 70
    data = @caffeineModel(doses,weight)

    times = []
    _.each(data, (e) ->
      times.push(e[0]))

    alldata = []
    _.each(data, (e) ->
      alldata.push(e[1])
      alldata.push(e[2]))

    margin = {top:20, bottom: 60, left:80, right:40}
    width = full_width - margin.left - margin.right
    height = full_height - margin.top - margin.bottom

    outer_wrap = d3.select("#graph-container")
                   .attr("width",full_width)
                   .attr("height",full_height)

    inner_wrap = outer_wrap.append("g")
                           .attr("transform","translate("+margin.left+","+margin.top+")")

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
                  #.ticks()

    yAxis = d3.svg.axis()
                  .scale(y)
                  .orient('left')

    xAxis_handle = inner_wrap.append("g")
              .attr("class","axis")
              .attr("transform","translate(0," + height + ")")
              .call(xAxis)

    yAxis_handle = inner_wrap.append("g")
                             .attr("class","axis")
                             .call(yAxis)

    blood_line_function = d3.svg.line()
                    .x( (d) -> return x(d[0]) )
                    .y( (d) -> return y(d[1]) )
                    #.interpolate("linear")

    unabsorbed_line_function = d3.svg.line()
                    .x( (d) -> return x(d[0]) )
                    .y( (d) -> return y(d[2]) )

    blood_line = inner_wrap.append("g")
                          .append("path")
                          .datum(data)
                          .attr("class","line")
                          .attr("d",blood_line_function(data))

    unabsorbed_line = inner_wrap.append("g")
                          .append("path")
                          .datum(data)
                          .attr("class","line")
                          .attr("d",unabsorbed_line_function(data))

    ###data_points = inner_wrap.append('g').selectAll('circle')
                             .data(data)
                          .enter()
                             .append("circle")
                             .attr("cx", (d) -> x(d[0]))
                             .attr("cy", (d) -> y(d[1]))
                             .attr("r",4)
                             .append("circle")
                             .attr("cx", (d) -> x(d[0]))
                             .attr("cy", (d) -> y(d[1]))
                             .attr("r",4)###

  caffeineModel: (doses,weight) =>
    # Doses: array of tuples.
    #   [0] -> Time of dose
    #   [1] -> Dosage in mg
    #
    # Weight: weight of the person being simulated, in kg.
    #
    # Returns an array of triples:
    # [[timestamp,blood_concentration,unabsorbed_concentration],[etc],[etc]]

    maxiters = 100000 # max iterations of the ODE solver

    caffeineSystem = (t,concs) ->
      tau = 1/5
      a = 1
      b_conc = concs[0] # blood concentration
      c_conc = concs[1] # unabsorbed caffeine concentration
      return [(a*c_conc - tau*b_conc),(-a*c_conc)]
      # dB/dt = a*C - tau*B
      # dC/dt = -a*C

    if doses.length < 1
      doses = [[0,0]]

    data = []
    initial_conditions = [0,0]
    startt = 0

    _.each(doses, (dose,num) ->

      if (num+2) <= doses.length
        endt = doses[num+1][0] # end when the next dose is taken
      else
        endt = 24 # otherwise end at the end of the day

      init_b = initial_conditions[0]
      init_c = initial_conditions[1] + (dose[1] / weight)

      sol = numeric.dopri(startt,endt,[init_b,init_c],caffeineSystem,1e-6,maxiters)

      times = _.range(startt,endt,endt/2000) # create some time values
      concentrations = sol.at(times) # grab concentrations for each time

      initial_conditions = concentrations[concentrations.length-1] # where we end the last state is where we pick up next time
      startt = endt # pick up where we left off

      _.each(times, (e,i) ->
        data.push([e,concentrations[i][0],concentrations[i][1]])))
    return data

###############################################################################
$( document ).ready( ->
  full_width = $( window ).width()
  full_height = $( window ).height()
  chart = new caffeineChart
  chart.renderGraph(full_width,full_height)
  return)

