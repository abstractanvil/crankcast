angular.module 'crankcast', []
  .filter 'percent', ['$filter', ($filter) ->
    (d) -> $filter('number')(d * 100, 0) + '%'
  ]

  .filter 'degrees', ['$filter', ($filter) ->
    (d) -> $filter('number')(d, 0) + '°'
  ]
      
  .factory 'location', ['$q', ($q) ->
    get: ->
      $q (resolve, reject) ->
        navigator.geolocation.getCurrentPosition (p, e) ->
          resolve
            lat: p.coords.latitude,
            lon: p.coords.longitude
  ]
    
  .factory 'forecasts', ['$http', '$q', ($http, $q) ->
    cacheKey = 'crankcast-cache'

    writeCache = (forecast) ->
      toCache =
        timestamp: Date.now()
        data: forecast

      localStorage.setItem cacheKey, JSON.stringify(toCache)

    readCache = ->
      cached = localStorage.getItem cacheKey 
      if cached then JSON.parse(cached) else undefined

    canUseCache = (cache) ->
      cache &&
      ((Date.now() - cache.timestamp) < (15 * 60 * 1000)) # 15 minutes

    cache: () -> 
      $q (resolve, reject) ->
        cache = readCache()
        if canUseCache(cache)
          resolve(cache.data)
        else
          reject()
          
    get: (location, date, am, pm) ->
      $q (resolve, reject) ->
        $http.get("/api/forecast/#{location.lat},#{location.lon},#{date},#{am},#{pm}").then(
          (data) ->
            writeCache(data.data)
            resolve(data.data)
          (error) -> reject(error)
    )
  ]

  .controller 'MainController', ['forecasts', 'location', (forecasts, location) ->
    vm = @

    vm.today = moment()

    vm.am = moment().hours(7).minutes(0).seconds(0)

    vm.pm = moment().hours(17).minutes(0).seconds(0) 
    
    vm.showTime = (m) -> moment(m * 1000).format('h:mm a')

    vm.showDate = (m) -> moment(m).calendar(null, { 
      sameDay: '[Today]', 
      nextDay: '[Tomorrow]',
      nextWeek: 'dddd'
    })

    vm.showIntensity = (i) ->
      switch
        when i == 0 then ''
        when i <= 0.002 then 'very light'
        when i <= 0.017 then 'light'
        when i <= 0.1 then 'moderate'
        when i <= 0.4 then 'heavy'
        else 'very heavy'

    vm.showSun = (sun, time) ->
      moment(sun * 1000).from(moment(time * 1000))

    vm.showWind = (w) -> "#{Math.round(w)} mph winds"

    getForecast = (l) -> 
      dateFormat = 'YYYY-MM-DD'
      timeFormat = 'HH:mm:ssZ'
      
      forecasts.get(l, vm.today.format(dateFormat), vm.am.format(timeFormat), vm.pm.format(timeFormat))
        .then((data) -> vm.forecasts = data)
      
    forecasts.cache().then( 
      (cached) -> vm.forecasts = cached
      () -> location.get().then(getForecast)
    )

    vm
  ]
