// Generated by CoffeeScript 1.6.3
(function() {
  var caffeineChart,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  caffeineChart = (function() {
    function caffeineChart() {
      this.caffeineModel = __bind(this.caffeineModel, this);
    }

    caffeineChart.prototype.renderGraph = function(full_width, full_height) {
      var alldata, blood_line, blood_line_function, data, doses, height, inner_wrap, margin, outer_wrap, times, unabsorbed_line, unabsorbed_line_function, weight, width, x, xAxis, xAxis_handle, y, yAxis, yAxis_handle;
      doses = [[0, 0], [1, 20], [3, 10]];
      weight = 70;
      data = this.caffeineModel(doses, weight);
      times = [];
      _.each(data, function(e) {
        return times.push(e[0]);
      });
      alldata = [];
      _.each(data, function(e) {
        alldata.push(e[1]);
        return alldata.push(e[2]);
      });
      margin = {
        top: 20,
        bottom: 60,
        left: 80,
        right: 40
      };
      width = full_width - margin.left - margin.right;
      height = full_height - margin.top - margin.bottom;
      outer_wrap = d3.select("#graph-container").attr("width", full_width).attr("height", full_height);
      inner_wrap = outer_wrap.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
      x = d3.scale.linear().domain([_.min(times), _.max(times)]).range([0, width]);
      y = d3.scale.linear().domain([0, _.max(alldata)]).range([height, 0]);
      xAxis = d3.svg.axis().scale(x).orient('bottom');
      yAxis = d3.svg.axis().scale(y).orient('left');
      xAxis_handle = inner_wrap.append("g").attr("class", "axis").attr("transform", "translate(0," + height + ")").call(xAxis);
      yAxis_handle = inner_wrap.append("g").attr("class", "axis").call(yAxis);
      blood_line_function = d3.svg.line().x(function(d) {
        return x(d[0]);
      }).y(function(d) {
        return y(d[1]);
      });
      unabsorbed_line_function = d3.svg.line().x(function(d) {
        return x(d[0]);
      }).y(function(d) {
        return y(d[2]);
      });
      blood_line = inner_wrap.append("g").append("path").datum(data).attr("class", "line").attr("d", blood_line_function(data));
      return unabsorbed_line = inner_wrap.append("g").append("path").datum(data).attr("class", "line").attr("d", unabsorbed_line_function(data));
      /*data_points = inner_wrap.append('g').selectAll('circle')
                               .data(data)
                            .enter()
                               .append("circle")
                               .attr("cx", (d) -> x(d[0]))
                               .attr("cy", (d) -> y(d[1]))
                               .attr("r",4)
                               .append("circle")
                               .attr("cx", (d) -> x(d[0]))
                               .attr("cy", (d) -> y(d[1]))
                               .attr("r",4)
      */

    };

    caffeineChart.prototype.caffeineModel = function(doses, weight) {
      var caffeineSystem, data, initial_conditions, maxiters, startt;
      maxiters = 100000;
      caffeineSystem = function(t, concs) {
        var a, b_conc, c_conc, tau;
        tau = 1 / 5;
        a = 1;
        b_conc = concs[0];
        c_conc = concs[1];
        return [a * c_conc - tau * b_conc, -a * c_conc];
      };
      if (doses.length < 1) {
        doses = [[0, 0]];
      }
      data = [];
      initial_conditions = [0, 0];
      startt = 0;
      _.each(doses, function(dose, num) {
        var concentrations, endt, init_b, init_c, sol, times;
        if ((num + 2) <= doses.length) {
          endt = doses[num + 1][0];
        } else {
          endt = 24;
        }
        init_b = initial_conditions[0];
        init_c = initial_conditions[1] + (dose[1] / weight);
        sol = numeric.dopri(startt, endt, [init_b, init_c], caffeineSystem, 1e-6, maxiters);
        times = _.range(startt, endt, endt / 2000);
        concentrations = sol.at(times);
        initial_conditions = concentrations[concentrations.length - 1];
        startt = endt;
        return _.each(times, function(e, i) {
          return data.push([e, concentrations[i][0], concentrations[i][1]]);
        });
      });
      return data;
    };

    return caffeineChart;

  })();

  $(document).ready(function() {
    var chart, full_height, full_width;
    full_width = $(window).width();
    full_height = $(window).height();
    chart = new caffeineChart;
    chart.renderGraph(full_width, full_height);
  });

}).call(this);
