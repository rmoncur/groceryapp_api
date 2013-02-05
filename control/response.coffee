module.exports = ()=>
	error: (error, res)->
		res.json {error: error.error, message: error.message}, error.code if not user?