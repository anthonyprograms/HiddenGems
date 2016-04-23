var db = require('../db')

var User = db.model('User', {
    userId: { type: String, required: true },
    email: { type: String, required: true },
    strikes: { type: Number, default: 0 }
})

module.exports = User
