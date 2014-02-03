// Generated by CoffeeScript 1.6.3
(function() {
  var background, blood_conc, full_height, full_width, height, inner_wrap, margin, outer_wrap, width, x, xAxis, y, yAxis;

  full_width = $(window).height();

  full_height = $(window).width();

  margin = {
    top: 30,
    bottom: 30,
    left: 30,
    right: 30
  };

  width = full_width - margin.left - margin.right;

  height = full_height - margin.top - margin.bottom;

  outer_wrap = d3.select(".chart").attr("width", full_width).attr("height", full_height);

  inner_wrap = outer_wrap.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  background = inner_wrap.append("rect").attr("width", "100%").attr("height", "100%").attr("fill", "red");

  x = d3.time.scale().domain().range();

  y = d3.scale.linear().domain().range();

  xAxis = d3.svg.axis().scale(x).orient('bottom').ticks();

  yAxis = d3.svg.axis().scale(y).orient('left');

  blood_conc = d3.svg.line().x(function(d) {
    return d;
  }).y(function(d) {
    return d;
  }).interpolate("linear");

  ({
    caffeineModel: function(doses) {
      var absorption, tau;
      tau = 1 / 5;
      return absorption = 1;
    }
  });

}).call(this);
