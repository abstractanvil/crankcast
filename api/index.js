var express = require('express'),
    router = express.Router(),
    http = require('https'),
    config = require('../config');

router.get('/forecast/:lat,:lon,:am,:pm', function(req, res, next) {

  var url = `https://api.forecast.io/forecast/${config.forecast.apiKey}/${req.params.lat},${req.params.lon}`;

  var amUrl = `${url},${req.params.am}`;

  var pmUrl = `${url},${req.params.pm}`;
  
  var forecast = {};

  http.get(amUrl, function (amRes) {
    amRes.on('data', function (d) {
      forecast.am  = JSON.parse(d.toString('utf8')).currently;

      http.get(pmUrl, function (pmRes) {
        pmRes.on('data', function(d) {
          forecast.pm = JSON.parse(d.toString('utf8')).currently;
          res.json(forecast);
        });
      });
    });
  });
});

module.exports = router;
