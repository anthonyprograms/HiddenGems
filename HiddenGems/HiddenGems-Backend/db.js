var mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/hiddengems', function () {
    console.log('mongodb connected');
})

module.exports = mongoose;
