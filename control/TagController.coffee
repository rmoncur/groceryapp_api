response = require('./ResponseMethods')()
tokenGenerator = require('./TokenGenerator')()

module.exports = (Tag) =>
	errors =
		TAG_NOT_FOUND: 
			error: true
			message: "Not Found"
			code: 404
		NOT_AUTHENTICATED: 
			error: true
			message: "Not Authenticated"
			code: 401
		ALREADY_EXISTS: 
			error: true
			message: "Conflict: Tag Already Exists"
			code: 409

	createTag: (req, res)=>
		body = req.body
		name = body.name
		console.log req
		console.log body
		#Tag.getTag name, (err, tag)=>
		#	return res.json {error: true, message: err.message}, 500 if err?
			#if tag?
			#	if ((tag.userId == body.user_id) && (body.user != 0))?
			#		return response.error errors.ALREADY_EXISTS, res if tag?
		tag = new Tag body
		tag.save (err) =>
			return res.send {error: true, message: err.message}, 500 if err?
			result = normalize tag
			res.json result

	getTagsByUser: (req, res) =>
		console.log "getTagsByUser"
		user_id = req.params.user_id
		console.log user_id
		Tag.getTagsByUser user_id, (err, tags) =>
			return res.json {error: true, message: err.message}, 500 if err?
			res.json tags

	getCategories: (req, res) =>
		Tag.getCategories

	getTagsByCategory: (req, res) =>
		console.log "getTagsByCategory"
		Tag.getTagsByCategory req.query.category_id

	getTag: (req, res) =>
		console.log "getTag"
		Tag.getTag req.query.tag_id, (err, tag) =>
			return res.json {error: true, message: err.message}, 500 if err?
			res.json tag

	searchTags: (req, res) =>
		console.log "searchTags"
		Tag.searchTags req.query.search, (err, tag) =>
			return res.json {error: true, message: err.message}, 500 if err?
			res.json tag

	deleteTag: (req, res) =>
		tag_id = req.params.tag_id
		Tag.deleteTagById tag_id, (err, user) =>
			return res.json {error: true, message: err.message}, 500 if err?
			res.json {message: "deleted"}, 200

base = ()-> [
      'tag_id'
      'userId'
      'name'
      'category'
  ]

normalize = (tag) ->
	result = {}
	fields = base()
	
	for key in fields
		if tag[key]?
        	result[key] = tag[key]
    	else if key is 'tag_id' and tag._id?
        	result[key] = tag._id
	
	return result