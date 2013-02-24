response = require('./ResponseMethods')()
#Item = require('../model/Item')

module.exports = (Purchase) =>
	errors =
		PRODUCT_NOT_FOUND: 
			error: true
			message: "Not Found"
			code: 404
		BARCODE_REQUIRED:
			error: true
			message: "A barcode is required"
			code: 409
  
#	updateProduct: (req, res) =>
#    product_id = req.params.product_id
#    name = req.body.name
#    description = req.body.description
#    size = req.body.size
#    barcode = req.body.barcode
#    barcode = "0#{barcode}" if barcode?.length is 12
#    
#    Product.getProductById product_id, (err, product) =>
#      return res.json {error: true, message: err.message}, 500 if err?
#      return response.error errors.PRODUCT_NOT_FOUND, res if not product?
#      product.name = name if name?
#      product.description = description if description?
#      product.size = size if size?
#      product.barcode = barcode if barcode?
#      product.lastUpdate = new Date
#      product.save()
#      
#      res.json product


	createPurchase: (req, res)=>
	
		body = req.body
		
		purchase = new Purchase body
		purchase.save (err) =>
			return res.send {error: true, message: err.message}, 500 if err?
			res.json purchase
			
	getPurchasesForUser: (req, res) =>
	
		user_id = req.params.user_id
		
		#Maybe check if user exists?
		
		Purchase.getPurchasesForUser user_id, (err, purchases) =>
			return res.json {error: true, message: err.message}, 500 if err?
			res.json purchases
		
	deletePurchase: (req, res) =>
	
		purchase_id = req.params.purchase_id
		
		Purchase.deletePurchase purchase_id, (err, purchases) =>
			return res.json {error: true, message: err.message}, 500 if err?
			res.json {message: "deleted"}, 200
			
	updatePurchase: (req, res) =>
		
		purchase_id = req.params.purchase_id
		overwrite = req.query.overwrite
		res.json { message: "not finished" }, 500
		
		
      

errors = ()->
	PRODUCT_NOT_FOUND: 
		error: true
		message: "Not Found"
		code: 404
	BARCODE_REQUIRED:
		error: true
		message: "A barcode is required"
		code: 409

#base = ()-> [
#      'user_id'
#      'email'
#      'token'
#  ]

#normalize = (user) ->
#	result = {}
#	fields = base()
#	for key in fields
#		if user[key]?
#        result[key] = user[key]
#	for key in fields
#		if user[key]?
#        result[key] = user[key]
#    else if key is 'user_id' and user._id?
#        result[key] = user._id
#	
#  return result
