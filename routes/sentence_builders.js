var express = require('express');
var router = express.Router();

var mongoose = require('mongoose');

require('../models/sentence_builder.js');

var models = {
    'ch': mongoose.model('chSentenceBuilder'),
    'en': mongoose.model('enSentenceBuilder')
};

/* GET /sbs */
router.get('/', function(req, res, next) {
    var lan = req.params.lan || 'ch';
    var model = models[lan];
    if (model)
    {
        if (req.query.slim) {
            model.find({}, '_id', function(err, questions) {
                if (err) return next(err);
                res.json(questions);
            });
        } else {
            model.find({}, function(err, questions) {
                if (err) return next(err);
                res.json(questions);
            });
        }
    }
});

/* Get /sbs/id */
router.get('/:id', function(req, res, next) {
    var lan = req.params.lan || 'ch';
    var model = models[lan];
    if (model)
    {
        model.findById(req.params.id, function(err, question) {
            if (err) return next(err);
            res.json(question);
        });
    }
});

/* POST /sbs */
router.post('/', function(req, res, next) {
    var lan = req.params.lan || 'ch';
    var model = models[lan];
    if (model)
    {
        console.log(req.body);

        model.create(req.body, function(err, post) {
            if (err) return next(err);
            res.json(post);
        });
    }
});

/* DELETE /sbs/:id */
router.delete('/:id', function(req, res, next) {
    var lan = req.params.lan || 'ch';
    var model = models[lan];
    if (model)
    {
        model.findByIdAndRemove(req.params.id, req.body, function (err, post) {
            if (err) return next(err);
            res.json(post);
        });
    }
});

module.exports = router;
