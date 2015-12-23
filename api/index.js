var express = require('express'),
    router = express.Router(),
    http = require('https'),
    config = require('../config');

var getForecast = function(lat, lon, time) {
  var url = `https://api.forecast.io/forecast/${config.forecast.apiKey}/${lat},${lon},${time}`;

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

router.get('/forecast/:lat,:lon,:am,:pm', function(req, res, next) {
  var forecast = {};
  getForecast(req.params.lat, req.params.lon, req.params.am)
    .then(function(d) {
      forecast.am = d;
      return getForecast(req.params.lat, req.params.lon, req.params.pm);
    })
    .then(function(d) {
      forecast.pm = d;
      res.json(forecast);
    });
});

module.exports = router

