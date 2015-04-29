var mongoose = require('mongoose');

var QuestionSchema = new mongoose.Schema({
    lan: { type: String, default: 'ch'},
    text: String,
    level: { type: Number, default: 0 }, 
    grade: { type: Number, default: 0 },
});

module.exports = QuestionSchema;