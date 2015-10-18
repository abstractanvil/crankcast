var express = require('express'),
    router = express.Router();

router.get('/messages', function(req, res, next) {

/*
http.get(params, function (res) {
  res.statusCode.should.eql(200);

  res.on('data', function (d) {
    var messages = JSON.parse(d.toString('utf8'));
    messages.should.have.length(1);

    var actual = messages[0];

    actual.should.have.property('text').and.eql(expected.text);
    done();
  });
});
*/

  Message.find(function (err, messages) {
    res.json(messages);
  });
});

module.exports = router;
