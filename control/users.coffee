response = require './response'

module.exports = (User) =>
	errors = {
		USER_NOT_FOUND: {error: true, message: "Not Found", code: 401}
	}

	createUser: (req, res)=>
		body = req.body
		user = new User body
		user.save (err) =>
			return res.send {error: true, message: err.message}, 500 if err?
			res.json user

	getUser: (req, res) =>
		email = req.params.email
		User.getUser email, (err, user) =>
			return user.json {error: true, message: err.message}, 500 if err?
			if user not null
				res.json user
			else
				return res.json {error: true, message: errors.USER_NOT_FOUND.message}, errors.USER_NOT_FOUND.code

	deleteUser: (req, res) =>
		email = req.params.email
		User.getUser email, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			if user not null
				user.remove()
			res.json {message: "deleted"}, 200

	authenticateUser: (req, res, next)=>
		email = req.params.email
		User.getUser email, (err, obj) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return res.json response.error @errors.USER_NOT_FOUND if not user?
			password = req.params.password
			return res.json response.error @errors.USER_NOT_FOUND if user.password not password
			next(req, res)