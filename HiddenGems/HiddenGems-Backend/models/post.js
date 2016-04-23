var db = require('../db')

var Post = db.model('Post', {
    userId: { type: String, required: true },
    name: { type: String, required: true },
    imageUrl: { type: String, required: true },
    city: { type: String, required: true },
    state: { type: String, required: true },
    location: [ { type: Number, required: true },
                { type: Number, required: true }
              ],
    gems: { type: Number, default: 0 },
    description: { type: String, required: true },
    date: { type: Date, required: true, default: Date.now }
})

module.exports = Post
