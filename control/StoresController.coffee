request = require "request"

module.exports = () =>
	getNearbyStores: (req, res)=>
		url = "https://api.foursquare.com/v2/venues/search"
		url += "?ll="+req.query.lat + "," + req.query.lon
		url += "&radius=5000"
		url += "&categoryId=4bf58dd8d48988d118951735"
		url += "&intent=browse"
		url += "&v=20130305"
		url += "&client_id=NKEXRHWRFONUHQSMCJQQDCMTAB2MOBP3JEPVBSWRXV2JAIAK&client_secret=YHANQCMP4QVGH02B4OFACUW4XMR1IPBEHNJO15B0Z1VRDDVB" 
		options =
			url: url
			json: {}

		request.get options, (e, r, body)=>
			return res.json e if e
			return res.json {error: 401} if not body?.response?.venues?

			res.json normalize body.response.venues

	getClosestStore: (req, res)=>
		url = "https://api.foursquare.com/v2/venues/search"
		url += "?ll="+req.query.lat + "," + req.query.lon
		url += "&radius=5000"
		url += "&categoryId=4bf58dd8d48988d118951735"
		url += "&intent=browse"
		url += "&v=20130305"
		url += "&client_id=NKEXRHWRFONUHQSMCJQQDCMTAB2MOBP3JEPVBSWRXV2JAIAK&client_secret=YHANQCMP4QVGH02B4OFACUW4XMR1IPBEHNJO15B0Z1VRDDVB" 
		options =
			url: url
			json: {}

		request.get options, (e, r, body)=>
			return res.json e if e
			return res.json {error: 401} if not body?.response?.venues?

			closest = 10000
			closestItem = null

			for item in body.response.venues
				if item.location.distance < closest
					closest = item.location.distance
					closestItem = item

			return res.json {error: 401} if not closestItem?
			res.json normalize closestItem

	getAtTheStore: (req, res)=>
		url = "https://api.foursquare.com/v2/venues/search"
		url += "?ll="+req.query.lat + "," + req.query.lon
		url += "&radius=5000"
		url += "&categoryId=4bf58dd8d48988d118951735"
		url += "&intent=match"
		url += "&v=20130305"
		url += "&client_id=NKEXRHWRFONUHQSMCJQQDCMTAB2MOBP3JEPVBSWRXV2JAIAK&client_secret=YHANQCMP4QVGH02B4OFACUW4XMR1IPBEHNJO15B0Z1VRDDVB" 
		options =
			url: url
			json: {}

		request.get options, (e, r, body)=>
			return res.json e if e
			return res.json {error: 401} if body?.response?.venues?.length == 0 
			res.json normalize body.response.venues#.response.groups[0].items

	getMyStores: (req, res)=>
		res.json {success: true, code: 200}



normalize = (stores)->
	if stores?.filter? 
		stores.filter (store)->
			keep = store.verified && store.categories.id == "4bf58dd8d48988d118951735"
			store.address = store.location.address
			store.lat = store.location.lat
			store.lon = store.location.lon
			store.distance = store.location.distance
			store.postalcode = store.location.postalcode
			store.city = store.location.city
			store.state = store.location.state
			store.country = store.location.country
			store.phone = store.contact.phone

			delete store.location
			delete store.contact

			delete store.categories
			delete store.stats
			delete store.likes
			delete store.hereNow
			delete store.referralId
			delete store.specials
			delete store.verified
			delete store.restricted
			delete store.canonicalUrl

			return keep
		return stores
	else
		store = stores
		store.address = store.location.address
		store.lat = store.location.lat
		store.lon = store.location.lon
		store.distance = store.location.distance
		store.postalcode = store.location.postalcode
		store.city = store.location.city
		store.state = store.location.state
		store.country = store.location.country
		store.phone = store.contact.phone

		delete store.location
		delete store.contact

		delete store.categories
		delete store.stats
		delete store.likes
		delete store.hereNow
		delete store.referralId
		delete store.specials
		delete store.verified
		delete store.restricted
		delete store.canonicalUrl
		return store





