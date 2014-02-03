renderGraph: (full_width,full_height) =>
  #data = caffeineModel(doses)

  margin = {top:30, bottom: 30, left:30, right:30}
  width = full_width - margin.left - margin.right
  height = full_height - margin.top - margin.bottom

  outer_wrap = d3.select(".chart")
                 .attr("width",full_width)
                 .attr("height",full_height)

  inner_wrap = outer_wrap.append("g")
                         .attr("transform","translate(#{margin.left},#{margin.top})")

  background = inner_wrap.append("rect")
                         .attr("width","100%")
                         .attr("height","100%")
                         .attr("fill","red")

  x = d3.time.scale()
             .domain()
             .range()

  y = d3.scale.linear()
              .domain()
              .range()

  xAxis = d3.svg.axis()
                .scale(x)
                .orient('bottom')
                .ticks()

  yAxis = d3.svg.axis()
                .scale(y)
                .orient('left')

  blood_conc = d3.svg.line()
                     .x( (d) -> return d)
                     .y( (d) -> return d)
                     .interpolate("linear")

caffeineModel: (doses) ->
  # Doses: array of tuples.
  #   [0] -> Time of dose
  #   [1] -> Dosage in mg
  #
  # Returns an array of triples:
  # [[timestamp,blood_concentration,unabsorbed_concentration],[etc],[etc]]

  tau = 1/5
  absorption = 1

  # dC/dt = -a*C
  # dB/dt = a*C - tau*B


$( document ).ready( => 
  full_width = $( window ).height()
  full_height = $( window ).width()
  @renderGraph(full_width,full_height))

