response = require('./ResponseMethods')()
tokenGenerator = require('./TokenGenerator')()

module.exports = (Tag) =>
	errors =
		TAG_NOT_FOUND: 
			error: true
			message: "Not Found"
			code: 401
		NOT_AUTHENTICATED: 
			error: true
			message: "Not Authenticated"
			code: 401

	createTag: (req, res)=>
		Tag.getTag email, (err, user)=>
			return res.json {error: true, message: err.message}, 500 if err?
			return res.json normalize user if user?.password is password
			
			body = req.body
			body.token = tokenGenerator.generateToken()
			user = new User body
			user.save (err) =>
				return res.send {error: true, message: err.message}, 500 if err?
				result = normalize user
				res.json result 

	getTag: (req, res) =>
		tag_id = req.params.tag_id
		Tag.getTagById tag_id, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.TAG_NOT_FOUND, res if not tag?
			tag = tag[0]
			res.json normalize tag

	deleteTag: (req, res) =>
		tag_id = req.params.tag_id
		Tag.deleteTagById tag_id, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			res.json {message: "deleted"}, 200
