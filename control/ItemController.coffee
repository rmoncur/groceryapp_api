response = require('./ResponseMethods')()

module.exports = (Item) =>

	createItem: (req, res) =>
		item = new Item req.body
		
		missingFields = new Array()
		
		missingFields.push("price") if not item.price?
		missingFields.push("store_id") if not item.store_id?
		missingFields.push("product_id") if not item.product_id?
		missingFields.push("user_id") if not item.user_id?	
		
		if req.body.date and not validDate(req.body.date)
			return response.error errors.INVALID_DATE, res
			
		return res.json errors.requiredField(missingFields), 409 if missingFields.length > 0
		
		item.save (err) =>
			return res.json { error: true, message: err.message }, 500 if err?
			res.json normalize(item), 201

	getItem: (req, res) => 
		item_id = req.params.item_id
		
		Item.getItemById item_id, (err, item) ->
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.ITEM_NOT_FOUND, res if not item?
			res.json normalize(item)

	updateItem: (req, res) =>
		item_id = req.params.item_id
		
		Item.getItemById item_id, (err, item) ->
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.ITEM_NOT_FOUND, res if not item?
			
			item.price = req.body.price if req.body.price?
			item.store_id = req.body.store_id if req.body.store_id?
			item.product_id = req.body.product_id if req.body.product_id?
			item.date = req.body.date if req.body.date?
			item.purchased = req.body.purchased if req.body.purchased?
			
			item.save (err) ->
				return res.json err, 409 if err?.message is "Validation failed"
				return res.json {error: true, message: err.message}, 500 if err?
			
				res.json normalize(item)

validDate = (date) =>
	not isNaN(Date.parse(date))

errors = {
	requiredField: (fields) ->
		return {
			error: true, 
			message: "required fields missing",
			fields: fields
		}
	ITEM_NOT_FOUND:
		error: true,
		message: "Item not found",
		code: 404
	INVALID_DATE:
		error: true,
		message: "Invalid date",
		code: 409
}

base = [
	'price'
	'store_id'
	'item_id'
	'product_id'
	'user_id'
	'date'
	'purchased'
]

normalize = (item) ->
	result = {}
	for key in base
		if key is "item_id" and item._id?
			result[key] = item._id
		else 
			result[key] = item[key]
	return result

