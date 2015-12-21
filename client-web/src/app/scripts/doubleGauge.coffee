angular.module 'crankcast'
  .directive 'doublegauge', [ ()->

    link = (scope, element) ->
      scope.$watch 'forecast', (n, o) ->
        forecast = scope.forecast
        return unless forecast?

        margin = {top: 8, right: 8, bottom: 8, left: 8}
        width = scope.width - margin.left - margin.right
        height = scope.height - margin.top - margin.bottom
        needleLength = width

        temperature = 32
        precip = 0.3

        leftScale = d3.scale.linear()
          .domain([0, 100]) # temperature
          .range([0, -70]) # rotation

        rightScale = d3.scale.linear()
          .domain([0, 1]) # precip probability
          .range([0, 70]) # rotation

        leftBg = d3.svg.arc()
          .innerRadius(0)
          .outerRadius(height)
          .startAngle(leftScale(0) * (Math.PI / 180) + (Math.PI/2)) # degrees * (pi/180)
          .endAngle(leftScale(100) * (Math.PI / 180) + (Math.PI/2));

        goodTemp = d3.svg.arc()
          .innerRadius(0)
          .outerRadius(height)
          .startAngle(leftScale(32) * (Math.PI / 180) + (Math.PI/2)) # degrees * (pi/180)
          .endAngle(leftScale(90) * (Math.PI / 180) + (Math.PI/2));

        rightBg = d3.svg.arc()
          .innerRadius(0)
          .outerRadius(height)
          .startAngle(rightScale(0) * (Math.PI / 180) - (Math.PI/2))
          .endAngle(rightScale(1) * (Math.PI / 180) - (Math.PI/2));

        goodPrecip = d3.svg.arc()
          .innerRadius(0)
          .outerRadius(height)
          .startAngle(rightScale(0) * (Math.PI / 180) - (Math.PI/2))
          .endAngle(rightScale(0.9) * (Math.PI / 180) - (Math.PI/2));


        svg = d3.select(element[0]).append('svg')
          .attr('width', width + margin.left + margin.right)
          .attr('height', height + margin.top + margin.bottom)
          .append('g')
            .attr('transform', "translate(#{margin.left}, #{margin.top})")

        left = svg.append('g')
          .attr('transform', 'translate(212, 0)')

        left.append('path')
          .attr('d', leftBg)
          .attr('stroke', 'rgba(0,0,0,0.1)')
          .attr('fill', 'none')
          .attr('transform', "translate(0, #{height})")

        left.append('path')
          .attr('d', goodTemp)
          .attr('fill', 'rgba(0, 255, 0, 0.2)')
          .attr('transform', "translate(0, #{height})")

        leftLine = left.append('g').append('line')
          .attr('x1', 0)
          .attr('y1', height)
          .attr('x2', width)
          .attr('y2', height)
          .attr('stroke-width', 5)
          .attr('stroke', '#000')
          .attr('transform', "rotate(#{leftScale(temperature)} 0 #{height})")

        right = svg.append('g')
          .attr('transform', 'translate(-212, 0)')

        right.append('path')
          .attr('d', rightBg)
          .attr('stroke', 'rgba(0,0,0,0.1)')
          .attr('fill', 'none')
          .attr('transform', "translate(#{width}, #{height})")

        right.append('path')
          .attr('d', goodPrecip)
          .attr('fill', 'rgba(0, 255, 0, 0.2)')
          .attr('transform', "translate(#{width}, #{height})")

        rightLine = right.append('g').append('line')
          .attr('x1', 0)
          .attr('y1', height)
          .attr('x2', width)
          .attr('y2', height)
          .attr('stroke-width', 5)
          .attr('stroke', '#00f')
          .attr('transform', "rotate(#{rightScale(precip)} #{width} #{height})")


    restrict: 'E'
    link: link
    scope: {forecast:'=', width: '=', height: '='}
  ]
