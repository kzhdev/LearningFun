var mongoose = require('mongoose');
var extend = require('mongoose-schema-extend');
var QuestionSchema = require('./question_schema');

var enSentenceBuilderSchema = QuestionSchema.extend({
    lan: { type: String, default: 'en' }
});

var ChSentenceBuilder = mongoose.model('chSentenceBuilder', QuestionSchema);
var EnSentenceBuilder = mongoose.model('enSentenceBuilder', enSentenceBuilderSchema);