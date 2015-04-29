var mongoose = require('mongoose');
var extend = require('mongoose-schema-extend');
var QuestionSchema = require('./question_schema');

var chPlaceMissingWordSchema = QuestionSchema.extend({
    noisies: [String]
});

var enPlaceMissingWordSchema = ChPlaceMissingWordSchema.extend({
    lan: { type: String, default: 'en'}
});

mongoose.model('chPlaceMissingWord', chPlaceMissingWordSchema);
mongoose.model('enPlaceMissingWord', enPlaceMissingWordSchema);