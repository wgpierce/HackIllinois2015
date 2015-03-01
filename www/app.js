var watson = require('watson-developer-cloud-alpha');
var concept_insights = watson.concept_insights({
    username: '1ac8e130-c589-4837-a447-efee6f85f67b',
    password: 'W9XVVaOuP8Rr',
    version: "v1"
});

var express = require('express');
var bodyParser = require('body-parser');
var cors = require('cors');
var app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(cors());

var server = app.listen(3000, function() {

    var host = server.address().address;
    var port = server.address().port;
    console.log("App.js listening att http://%s:%s", 'localhost', port);
});

app.post('/', function(req, res) {
    var params = {
      user: 'wikipedia',
      graph: 'en-20120601',
      text: req.body.key1
    };
    
    concept_insights.annotateText(params, function(err, response) {
        if (err) {
            res.send(err);
        } else {
            res.send(response);
        }
    });
});

/*
var params = {
  user: 'wikipedia',
  graph: 'en-20120601',
  text: 'Current Events News Sports Comedy Standup Comedy Talk shows celebrity Elon Musk'
};
 
// Retrieve the concepts for input text 
concept_insights.annotateText(params, function(err, response) {
  if (err)
    console.log(err);
  else
    console.log(JSON.stringify(response, null, 2));
});
*/