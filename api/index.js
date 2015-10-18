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

  http.get(url, function (fRes) {
    fRes.on('data', function (d) {
      var forecast = JSON.parse(d.toString('utf8'));
      res.json(forecast.currently);
    });
  });
});

module.exports = router;
