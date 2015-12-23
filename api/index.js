var express = require('express'),
    router = express.Router(),
    http = require('https'),
    config = require('../config');

router.get('/forecast/:lat,:lon,:am,:pm', function(req, res, next) {

  var url = `https://api.forecast.io/forecast/${config.forecast.apiKey}/${req.params.lat},${req.params.lon}`;

  var amUrl = `${url},${req.params.am}`;

  var pmUrl = `${url},${req.params.pm}`;
  
  var forecast = {};

  // TODO refactor with promises and es6
  http.get(amUrl, function (amRes) {
    var amData = '';
    amRes.setEncoding('utf8');

    amRes.on('data', function (d) {
      amData += d;
    });

    amRes.on('end', function () {
      forecast.am  = JSON.parse(amData).currently;

      http.get(pmUrl, function (pmRes) {
        var pmData = '';
        pmRes.setEncoding('utf8');

        pmRes.on('data', function(d) {
          pmData += d;
        });

        pmRes.on('end', function () {
          forecast.pm = JSON.parse(pmData).currently;
          res.json(forecast);
        });
      });
    });
  });
});

module.exports = router;
