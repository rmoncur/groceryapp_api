request = require "request"

module.exports = (Subscriber) =>
	addSubscriber: (req, res)=>
		uri = req.body.uri
		Subscriber.find {uri: uri}, (err, subscriber)=>
			return res.json err if err
			return res.json {code : 304, message : "Not Modified"} if subscriber?

			Subscriber subscriber = new Subscriber {uri : uri}
			subscriber.save (err)=>
				return res.json err if err
				res.json {code : 200, message : "OK"}

	removeSubscriber: (req, res)=>
		res.json {code : 200, message : "Not yet implemented"}