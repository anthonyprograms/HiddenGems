var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var Post = require('./models/post');
var User = require('./models/user');

var app = express();
app.use(bodyParser.json());

// Find post by ID
app.get('/post/id', function (req, res, next) {
    Post.find({ "_id": req.query._id })
    .exec(function(err, post) {
        if (err) { return next(err) }
        res.json(post)
    })
})

// Return all posts to be displayed
app.get('/posts', function (req, res, next) {
	Post.find({ location: { $geoWithin: { $centerSphere: [ [ req.query.longitude, req.query.latitude ], 3000/3963.2 ] }}}, 
		{"city": false, "state": false, "description": false}, 
		{ limit : 15 })    
    .sort('-date')
    .exec(function(err, posts){
        if (err) { return next(err) }
        res.json(posts)
    })
})

// Create a new post
app.post('/posts', function (req, res, next) {
    var post = new Post({
        userId: req.body.userId,
        name: req.body.name,
        imageUrl: req.body.imageUrl,
        city: req.body.city,
        state: req.body.state,
        location: [ req.body.longitude,
                	req.body.latitude
                  ],
        description: req.body.description
    })

    post.save(function (err, resp) {
        if (err) { return next(err) }
        res.status(201).json(resp)
    })
})

// Increment post's gems
app.put('/posts/increment', function (req, res, next) {
    Post.update({ _id: req.body._id}, { $inc: { gems: 1}})
    .exec(function(err, post){
        if (err) { return next(err) }
        res.json(post)
    })
})

// Decrement post's gems
app.put('/posts/decrement', function (req, res, next) {
    Post.update({_id: req.body._id}, { $inc: { gems: -1}})
    .exec(function(err, post){
        if (err) { return next(err) }
        res.json(post)
    })
})

// Get a user by ID
app.get('/users', function (req, res, next) {
    User.find({"userId": req.query.userId})
    .exec(function(err, user) {
        if (err) { return next(err) }
        res.json(user)
    })
})

// Get all users
app.get('/allUsers', function (req, res, next) {
    User.find({})
    .exec(function(err, posts){
        if (err) { return next(err) }
        res.json(posts)
    })
})

// Create a user
app.post('/users', function (req, res, next) {
    //console.log(req.body.userId, req.body.email)
    var user = new User({
        userId: req.body.userId,
        email: req.body.email
    })

    user.save(function (err, resp) {
        if (err) { return next(err) }
        res.status(201).json(resp)
    })
})

// Update the amount of deleted posts for a user
app.put('/users', function (req, res, next) {
	console.log(req.body.userId, req.body.strikes)
    User.update({"userId": req.body.userId}, 
    	{ $set: {"strikes": req.body.strikes }
    })
})

app.listen(8080, function () {
    console.log('Server listening on', 8080);
});
