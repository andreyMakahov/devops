"use strict";
var express = require('express');
var port = require('../config/env').port;
var app = express();
app.get('/', function (req, res) {
    var response = 'Hello world. It is nice to meet you!';
    res.end(response);
});
app.listen(port, function () { return console.log("Listening on port " + port); });
