var express = require('express'),
    router = express.Router(),
    http = require('https'),
    config = require('../config'),
    moment = require('moment');

var getForecast = function(lat, lon, date, time) {
  var url = `https://api.forecast.io/forecast/${config.forecast.apiKey}/${lat},${lon},${date}T${time}`;

  console.log(url);

  return new Promise(function(resolve, reject) {
    http.get(url, function(res) {
      var data = '';
      res.setEncoding('utf8');

      res.on('data', (d) => { data += d; });

      res.on('end', function() {
        // TODO json parsing error handling
        var forecast = JSON.parse(data).currently;
        resolve(forecast);
      });
    });
  });
}

router.get('/forecast/:lat,:lon,:date,:am,:pm', function(req, res, next) {

  var forecasts = [
    {
      date: req.params.date
    },
    {
      date: moment(req.params.date).add(1, 'day').format('YYYY-MM-DD')
    }
  ];
  
  getForecast(req.params.lat, req.params.lon, req.params.date, req.params.am)
    .then(function(d) {
      forecasts[0].am = d;
      return getForecast(req.params.lat, req.params.lon, req.params.date, req.params.pm);
    })
    .then(function(d) {
      forecasts[0].pm = d;
      return getForecast(req.params.lat, req.params.lon, forecasts[1].date, req.params.am);
    })
    .then(function(d) {
      forecasts[1].am = d;
      return getForecast(req.params.lat, req.params.lon, forecasts[1].date, req.params.pm);
    })
    .then(function(d) {
      forecasts[1].pm = d;
      res.json(forecasts);
    });
});

module.exports = router

