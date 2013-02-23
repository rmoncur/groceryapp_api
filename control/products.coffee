response = require('./response')()
http = require('http')

module.exports = (Product) =>
	errors =
		PRODUCT_NOT_FOUND: 
			error: true
			message: "Not Found"
			code: 404
		BARCODE_REQUIRED:
			error: true
			message: "A barcode is required" 
			code: 409
  
	updateProduct: (req, res) =>
    product_id = req.params.product_id
    name = req.body.name
    description = req.body.description
    size = req.body.size
    barcode = req.body.barcode
    barcode = "0#{barcode}" if barcode?.length is 12
    
    Product.getProductById product_id, (err, product) =>
      return res.json {error: true, message: err.message}, 500 if err?
      return response.error errors.PRODUCT_NOT_FOUND, res if not product?
      product.name = name if name?
      product.description = description if description?
      product.size = size if size?
      product.barcode = barcode if barcode?
      product.lastUpdate = new Date
      product.save()
      
      res.json product


	createProduct: (req, res)=>
		name = req.body.name
		size = req.body.size
		description = req.body.description
		barcode = req.body.barcode
		return response.error errors.BARCODE_REQUIRED, res if not barcode?
		
		Product.getProduct barcode, (err, product)=>
			return res.json {error: true, message: err.message}, 500 if err?
			return res.json product if product?
			
			body = req.body
			product = new Product body
			product.lastUpdate = new Date
			product.save (err) =>
				return res.send {error: true, message: err.message}, 500 if err?
				res.json product

	getProduct: (req, res) =>
		barcode = req.params.barcode
		#We will store all of our barcodes as 13 digit codes so if they are only 12 add the leading 0
		barcode = "0#{barcode}" if barcode.length is 12
		Product.getProduct barcode, (err, product) =>
			return res.json {error: true, message: err.message}, 500 if err?
			return findProduct barcode, res if not product?
			res.json product

  findProduct = (barcode, res) =>
    apikey = "187bd7a0e52dd56fd86e4ba25629084c"
    
    options = {
      hostname: "upcdatabase.org",
      path: "/api/json/#{apikey}/#{barcode}"
    }
    
    req = http.get options, (upcResponse) -> 
      output = ""
      
      upcResponse.on 'data', (chunk) -> 
        output += chunk
        
      upcResponse.on 'end', ->
        result = JSON.parse output
        if result.valid is "true"
          product = new Product {
            name: result.itemname,
            #If we requested a 12 digit number we'll convert it to a 13 digit
            barcode: if result.number.length is 13 then result.number else "0#{result.number}",
            description: result.description
          }
          product.save()
        else if barcode.length is 13
          #If we didn't find the 13 digit code at upcdatabase.org then we will see if they have a matching 12 digit code.
          return findProduct barcode.substring(1), res
        else
          return response.error errors.PRODUCT_NOT_FOUND, res

        res.json product
        
    req.on 'error', (e) ->
      console.log e.message
      

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
