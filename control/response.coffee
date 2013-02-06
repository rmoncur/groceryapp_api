module.exports = ()=>
	error: (err, res)->
		res.json {error: err.error, message: err.message}, err.code if not user?