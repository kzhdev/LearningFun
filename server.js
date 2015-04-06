var http = require('http');

var express = require('express');
var config = require('./config.js');
var xsrf = require('./server_lib/xsrf');
var protectJSON = require('./server_lib/protectJSON');
require('express-namespace');

var app = express();
var server = http.createServer(app);

// redirect http request to https
app.use(function(req, res, next) {
    if((!req.secure) && (req.get('X-Forwarded-Proto') !== 'https') &&
        req.get('Host').indexOf('localhost') === -1 &&
        req.get('Host').indexOf('127.0.0.1') === -1) {
        res.redirect('https://' + req.get('Host') + req.url);
        console.log('redirected http request to https');
    } else {
        next();
    }
});

require('./server_lib/routes/static').addRoutes(app, config);

app.set('port', process.env.PORT || config.server.listenPort);
app.use(protectJSON);

app.use(express.logger());                                  // Log requests to the console
app.use(express.cookieParser(config.server.cookieSecret));  // Hash cookies with this secret
app.use(express.cookieSession());                           // Store the session in the (secret) cookie
app.use(xsrf);                                              // Add XSRF checks to the request

require('./server_lib/routes/appFile').addRoutes(app, config);

// development only
if (app.get('env') === 'development') {
    // A standard error handler - it picks up any left over errors and returns a nicely formatted server 500 error
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
}

// Start up the server on the port specified in the config
server.listen(app.get('port'), function(){
    console.log('LearningFun app Server: ' + process.env.ENV_TYPE + ' - listening on port: ' + config.server.listenPort);
});
