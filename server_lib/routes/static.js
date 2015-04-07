var express = require('express');

exports.addRoutes = function(app, config) {
  // Serve up the favicon
  app.use(express.favicon(config.server.distFolder + '/favicon.ico'));

  // First looks for a static file: index.html, css, images, etc.
  app.use(config.server.staticUrl, express.compress());
  app.use(config.server.staticUrl, express.static(config.server.distFolder));

  // serve dart packages
  app.use(config.server.packagesUrl, express.static(config.server.packagesFolder));

  // serve font
  app.use(config.server.fontUrl, express.static(config.server.fontFolder));

  app.use(config.server.staticUrl, function(req, res, next) {
    res.send(404); // If we get here then the request for a static file is invalid
  });
};