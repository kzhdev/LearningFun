path = require('path');

module.exports = {
  server: {
    // The port on which the server is to listen (means that the app is at http://localhost:3000 for instance)
    listenPort: 4000,

    // The HTTPS port on which the server is to listen (means that the app is at https://localhost:8433 for instance)
    securePort: 8433,

    // The folder that contains the application files (note that the files are in a different repository) - relative to this file
    distFolder: path.resolve(__dirname, './public'),

    // The secret for encrypting the cookie
    cookieSecret: 'learning-app'
  }
};
