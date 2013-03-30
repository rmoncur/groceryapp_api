response = require('./ResponseMethods')()
tokenGenerator = require('./TokenGenerator')()
md5 = require('MD5')
normalizer = require('./Normalizers')()

module.exports = (User, Item) =>
	errors =
		USER_NOT_FOUND: 
			error: true
			message: "Not Found"
			code: 404
		NOT_AUTHENTICATED: 
			error: true
			message: "Not Authenticated"
			code: 401
		ALREADY_EXISTS: 
			error: true
			message: "Conflict: User Already Exists"
			code: 409

	login: (req, res)=>
		email = req.body.email
		password = req.body.password

		User.getUser email, (err, user)=>
			return res.json {error: true, message: err.message}, 500 if err?
			return res.json normalize user if user?.password is password
			return response.error errors.USER_NOT_FOUND, res

	createUser: (req, res)=>
		console.log req.body
		email = req.body.email
		password = req.body.password
		
		User.getUser email, (err, user)=>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.ALREADY_EXISTS, res if user?
			
			body = req.body
			body.points = 0
			body.token = tokenGenerator.generateToken()
			user = new User body
			user.save (err) =>
				return res.send {error: true, message: err.message}, 500 if err?
				result = normalize user
				res.json result 

	getUser: (req, res) =>
		user_id = req.params.user_id
		User.getUserById user_id, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.USER_NOT_FOUND, res if not user?
			user = user[0]
			res.json normalize user

	deleteUser: (req, res) =>
		user_id = req.params.user_id
		User.deleteUserById user_id, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			res.json {message: "deleted"}, 200

	authenticateUser: (req, res, next)=>
		#console.log req
		if req?.query
			user_id = req.query.user_id if req.query.user_id
			token = req.query.token if req.query.token
		else if req?.body
			user_id = req.body.user_id
			token = req.body.token
		#console.log user_id
		#console.log token
		if not token and req?.headers['authorization']?
			tokenStrings = req.headers['authorization'].split(" ")
			token = tokenStrings[1] if tokenStrings.length > 0
		if not user_id
			user_id = req.params.user_id

		
		return response.error errors.NOT_AUTHENTICATED, res if not token or not user_id

		User.getUserById user_id, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.USER_NOT_FOUND, res if not user?
			user = user[0]
			return response.error errors.USER_NOT_FOUND, res if not user?
			return response.error errors.NOT_AUTHENTICATED, res if user.token != token
			next user
			
	getItems: (req, res) =>
		user_id = req.params.user_id
		
		Item.getItemsByUserId user_id, (err, items) =>
			return res.json {error:true, message: err.message}, 500 if err?
			results = []
			results.push(normalizer.item(item)) for item in items
			res.json results

errors = ()->
	USER_NOT_FOUND: 
		error: true
		message: "Not Found"
		code: 401
	NOT_AUTHENTICATED: 
		error: true
		message: "Not Authenticated"
		code: 401

base = ()-> [
			'user_id'
			'email'
			'token'
			'username'
			'points'
	]

normalize = (user) ->
	result = {}
	fields = base()
	for key in fields
		if key is 'user_id' and user._id?
			result[key] = user._id
		else if user[key]?
			result[key] = user[key]
	
	result.img = 'http://www.gravatar.com/avatar/' + md5(result.email)
	result.level = getLevel(result.points)
	return result

getLevel = (points)->
	return Math.floor(points/10)
