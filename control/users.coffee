response = require('./response')()
tokenGenerator = require('./token')()

module.exports = (User) =>
	errors =
		USER_NOT_FOUND: 
			error: true
			message: "Not Found"
			code: 401
		NOT_AUTHENTICATED: 
			error: true
			message: "Not Authenticated"
			code: 401


	base: -> [
        'user_id'
        'email'
        'token'
    ]

	normalize: (user) =>
		result = {}
		fields = @base()
		for key in fields
			if user[key]?
          result[key] = user[key]
      else if key is 'user_id' and user._id?
          result[key] = user._id


	createUser: (req, res)=>
		body = req.body
		body.token = tokenGenerator.generateToken()
		user = new User body
		user.save (err) =>
			return res.send {error: true, message: err.message}, 500 if err?
			res.json user

	getUser: (req, res) =>
		email = req.query.email
		User.getUser email, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.USER_NOT_FOUND, res if not user?
			res.json user

	deleteUser: (req, res) =>
		email = req.params.email
		User.getUser email, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			if user not null
				user.remove()
			res.json {message: "deleted"}, 200

	authenticateUser: (data, res, next)=>
		user_id = data.user_id
		User.getUserById user_id, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.USER_NOT_FOUND, res if not user?
			user = user[0]
			console.log JSON.stringify user
			console.log data.token
			return response.error errors.NOT_AUTHENTICATED, res if user.token != data.token
			next user