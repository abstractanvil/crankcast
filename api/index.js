var express = require('express'),
    router = express.Router(),
    http = require('https'),
    config = require('../config');

router.get('/forecast/:lat,:lon,:time', function(req, res, next) {

  var url = "https://api.forecast.io/forecast/"
            + config.forecast.apiKey + "/"
            + req.params.lat + ","
            + req.params.lon + ","
            + req.params.time;

  /*
  http.get(url, function (fRes) {
    fRes.on('data', function (d) {
      var forecast = JSON.parse(d.toString('utf8'));
      res.json(forecast.currently);
    });
  });
  */

  var temp = {
    "time":1445338800,
    "summary":"Clear",
    "icon":"clear-night",
    "precipIntensity":0,
    "precipProbability":0,
    "temperature":42.31,
    "apparentTemperature":40.31,
    "dewPoint":35.8,
    "humidity":0.78,
    "windSpeed":3.66,
    "windBearing":204,
    "visibility":6.27,
    "cloudCover":0.14,
    "pressure":1027.7,
    "ozone":294.65
  };
  res.json(temp);


});

module.exports = router;
