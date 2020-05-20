var express = require('express');
var app = express();
var path = require('path');
var formidable = require('formidable');
var fs = require('fs');
var exec = require('child_process').exec;
var hotdog = process.env.HOT_DOG || true;
var model_server = process.env.MODEL_SERVER || '192.168.137.2:32195';
const request = require('request');

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'uploads')));

app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname, 'views/index.html'));
});

app.post('/upload', function (req, res) {
  //var ret = "<table><tr><th>Guess</th><th>Score</th></th></tr>";

  // create an incoming form object
  var form = new formidable.IncomingForm();

  // specify that we want to allow the user to upload multiple files in a single request
  form.multiples = true;

  // store all uploads in the uploads directory
  form.uploadDir = path.join(__dirname, 'uploads');

  // every time a file has been uploaded successfully,
  // rename it to it's orignal name
  form.on('file', function (field, file) {
    fs.rename(file.path, path.join(form.uploadDir, file.name), function (err) {
      if (err) throw err;
    });
    request("http://localhost:8081/classify?fn=/opt/uploads/" + file.name, { json: true },
      function (error, result, body) {        
        if (error) { return console.log(error); }
        console.log(body)
        var ret = '';
        ret += "<table><tr><th>SFW</th><th>NSFW</th></th></tr>";
        ret += "<tr><td>" + body.sfw + "</td>" + "<td>" + body.nsw + "</td></tr>"
        ret += '</table>';
        ret += '<img height="200" width="200" src="/' + file.name +'">'        
        res.end(ret);
      });
  });

  // log any errors that occur
  form.on('error', function (err) {
    console.log('An error has occured: \n' + err);
  });

  // once all the files have been uploaded, send a response to the client
  //form.on('end', function() {
  //  res.end('success');
  //});

  // parse the incoming request containing the form data
  form.parse(req);

});

var server = app.listen(8080, function () {
  console.log('Server listening on port 8080');
});
