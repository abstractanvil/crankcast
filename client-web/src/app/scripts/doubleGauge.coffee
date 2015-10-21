angular.module 'crankcast'
  .directive 'doublegauge', [ ()->

    link = (scope, element) ->
      scope.$watch 'forecast', (n, o) ->
        forecast = scope.forecast
        return unless forecast?

        d3.select(element[0]).append('p')
          .text(forecast.temperature)

    restrict: 'E'
    link: link
    scope: {forecast:'='}
  ]
