response = require('./ResponseMethods')()
#Item = require('../model/Item')
ObjectId = require('mongoose').Types.ObjectId


module.exports = (Purchase) =>
	errors = 
		PURCHASE_NOT_FOUND: 
			error: true
			message: "Purchase Not Found"
			code: 404
		ITEM_NOT_FOUND: 
			error: true
			message: "Item Not Found"
			code: 404
		USER_NOT_FOUND: 
			error: true
			message: "User Not Found"
			code: 404
		PRODUCT_NOT_FOUND: 
			error: true
			message: "Product Not Found"
			code: 404
		STORE_NOT_FOUND:
			error: true
			message: "Store Not Found"
			code: 404

	createPurchase: (req, res)=>
	
		body = req.body
		
		purchase = new Purchase body
		purchase.save (err) =>
			return res.send {error: true, message: err.message}, 500 if err?
			res.json purchase
			
	getPurchase: (req, res) =>
		
		purchase_id = req.params.purchase_id
		
		Purchase.getPurchaseById purchase_id, (err, purchase) =>
			return res.send {error: true, message: err.message}, 500 if err?
			return response.error errors.PURCHASE_NOT_FOUND, res if not purchase?
			
			res.json purchase
					
	getPurchasesForUser: (req, res) =>
	
		user_id = req.params.user_id
		
		#Maybe check if user exists?
		
		Purchase.getPurchasesForUser user_id, (err, purchases) =>
			return res.send {error: true, message: err.message}, 500 if err?
			res.json purchases
		
	deletePurchase: (req, res) =>
	
		purchase_id = req.params.purchase_id
		
		Purchase.deletePurchase purchase_id, (err, purchases) =>
			return res.send {error: true, message: err.message}, 500 if err?
			res.json {message: "deleted"}, 200
			
	updatePurchase: (req, res) =>
		
		#Only store_id, total, and purchaseDate can be updated
		purchase_id = req.params.purchase_id
		store_id = req.body.store_id
		total = req.body.total
		purchaseDate = req.body.purchaseDate
		
		Purchase.getPurchaseById purchase_id, (err, purchase) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.PURCHASE_NOT_FOUND, res if not purchase?
			
			purchase.store_id = store_id if store_id?
			purchase.total = total if total?
			purchase.purchaseDate = purchaseDate if purchaseDate?
			purchase.save()
			
			res.json purchase
		
	updateItem: (req, res) =>
			
		item_id = req.params.item_id
		price = req.body.price
		product_id = req.body.product_id
		
		Purchase.getPurchaseByItemId item_id, (err, purchase) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.ITEM_NOT_FOUND, res if not purchase?
			
			index = i for i in [0..purchase.items.length - 1] when purchase.items[i].id is item_id
			
			purchase.items[index].price = price if price?
			purchase.items[index].product_id = product_id if product_id?
			purchase.save()
			
			res.json purchase.items[index]
			
	deleteItem: (req, res) =>
		item_id = req.params.item_id
		
		Purchase.getPurchaseByItemId item_id, (err, purchase) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.ITEM_NOT_FOUND, res if not purchase?
			
			index = i for i in [0..purchase.items.length - 1] when purchase.items[i].id is item_id
			
			purchase.items.splice index, 1
			purchase.save()
			
			res.json {message: "deleted"}, 200
			
	addItemToPurchase: (req, res) =>
		purchase_id = req.params.purchase_id
		
		Purchase.getPurchaseById purchase_id, (err, purchase) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return response.error errors.PURCHASE_NOT_FOUND, res if not purchase?
			
			item = req.body
			purchase.items.push item
			purchase.save()
			
			res.json purchase
			
base = ()-> [
      'user_id'
      'items'
      'purchase_id'
      'store_id'
      'total'
      'purchase_date'
  ]

normalize = (purchase) ->
	result = {}
	fields = base()
	for key in fields
		if purchase[key]?
        result[key] = purchase[key]
	for key in fields
		if purchase[key]?
        result[key] = purchase[key]
    else if key is 'purchase_id' and purchase._id?
        result[key] = purchase._id
	
  return result
