exports.addRoutes = function (app, config) {
    app.get('/', function(req, res) {
        res.sendfile('index.html', { root: config.server.distFolder});
    });
};
