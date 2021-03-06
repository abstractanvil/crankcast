var express = require('express'),
    router = express.Router(),
    http = require('https'),
    config = require('../config'),
    moment = require('moment');

var getForecast = function(lat, lon, date, time) {
  var url = `https://api.forecast.io/forecast/${config.forecast.apiKey}/${lat},${lon},${date}T${time}`;

  return new Promise(function(resolve, reject) {
    http.get(url, function(res) {
      var data = '';
      res.setEncoding('utf8');

      res.on('data', (d) => { data += d; });

      res.on('end', function() {
        try {
          var forecast = JSON.parse(data);
          resolve(forecast);
        }
        catch (e) {
          reject(e);
        }
      });
    });
  });
}

router.get('/forecast/:lat,:lon,:date,:am,:pm', function(req, res, next) {

  var dateFormat = 'YYYY-MM-DD';

  var day = function(days) {
    if (days) {
      return moment(req.params.date).add(days, 'days').format(dateFormat);
    }
    else {
      return moment(req.params.date).format(dateFormat);
    }
  }

  var forecasts = [
    { date: day() },
    { date: day(1) }, 
    { date: day(2) },
    { date: day(3) }
  ];
  
  var promises = [];
  forecasts.forEach(function(forecast) {
    promises.push(getForecast(req.params.lat, req.params.lon, forecast.date, req.params.am));
    promises.push(getForecast(req.params.lat, req.params.lon, forecast.date, req.params.pm));
  });

  Promise.all(promises).then(function(d) {
    forecasts.forEach(function(forecast, i) {
      forecast.sunrise = d[i * 2].daily.data[0].sunriseTime;
      forecast.sunset = d[i * 2 + 1].daily.data[0].sunsetTime;
      forecast.am = d[i * 2].currently;
      forecast.pm = d[i * 2 + 1].currently;
    });

    res.json(forecasts);
  },
  function(d) {
    res.status(500).json({error: d});
  });
});

module.exports = router

