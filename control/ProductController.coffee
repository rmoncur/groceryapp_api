response = require('./ResponseMethods')()
http = require('http')
normalize = require('./Normalizers')()

module.exports = (Product, Item) => 

  errors = 
    PRODUCT_NOT_FOUND: 
      error: true
      message: "Not Found"
      code: 404
    BARCODE_REQUIRED:
      error: true
      message: "A barcode is required"
      code: 409
    PRODUCT_ALREADY_EXISTS:
      error: true
      message: "A product with the given barcode already exists"
      code: 409

  updateProduct: (req, res) =>
    product_id = req.params.product_id
    name = req.body.name
    description = req.body.description
    size = req.body.size
    barcode = req.body.barcode
#    barcode = "0#{barcode}" if barcode?.length is 12
    
    Product.getProductById product_id, (err, product) =>
      return res.json {error: true, message: err.message}, 500 if err?
      return response.error errors.PRODUCT_NOT_FOUND, res if not product?
      product.name = name if name?
      product.description = description if description?
      product.size = size if size?
      product.barcode = barcode if barcode?
      product.lastUpdate = new Date
      product.save (err) ->
        return res.json {error: true, message: err.message}, 500 if err?
      
        res.json normalize.product(product)


  createProduct: (req, res) =>
    name = req.body.name
    size = req.body.size
    description = req.body.description
    barcode = req.body.barcode
    user_id = req.body.user_id
    
    price = req.body.price
    store_id = req.body.store_id
    
    return response.error errors.BARCODE_REQUIRED, res if not barcode?
    
    Product.getProduct barcode, (err, product)=>
      return res.json {error: true, message: err.message}, 500 if err?
      return response.error errors.PRODUCT_ALREADY_EXISTS, res if product?
      
      body = req.body
      product = new Product body
      product.lastUpdate = new Date
      product.save (err) =>
        return res.send {error: true, message: err.message}, 500 if err?
        
        if store_id? and price?
          item = new Item body
          item.product_id = product.id
          item.save (err) =>
            console.log err if err?
            return res.send { error: true, message: err.message }, 500 if err?
#            console.log 'now here'
          
            return res.json { product: normalize.product(product), item: normalize.item(item) }, 201
        else
          res.json { product: normalize.product product }, 201
        

  getProducts: (req, res) =>
    name = ""
    name = req.query.query if req?.query?.query
    options = { $or: [ { description:new RegExp(name, 'i') }, { name:new RegExp(name, 'i') } ] }
    Product.getProducts options, (err, products)=>
      return res.json err if err
      return response.error errors.PRODUCT_NOT_FOUND, res if not products
      results = []
      results.push(normalize.product(product)) for product in products
      res.json results

  getProduct: (req, res) =>
    barcode = req.params.barcode
    #We will store all of our barcodes as 13 digit codes so if they are only 12 add the leading 0
#    barcode = "0#{barcode}" if barcode.length is 12
    Product.getProduct barcode, (err, product) =>
      return res.json {error: true, message: err.message}, 500 if err?
      return findProduct barcode, res if not product?
      res.json normalize.product(product)
      
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
              barcode: if result.number.length is 12 then "0#{result.number}" else result.number,
              description: result.description
            }
            product.save()
          else if barcode.length is 13
            #If we didn't find the 13 digit code at upcdatabase.org then we will see if they have a matching 12 digit code.
            return findProduct barcode.substring(1), res
          else
            return response.error errors.PRODUCT_NOT_FOUND, res

          res.json normalize.product product

      req.on 'error', (e) ->
        console.log e.message

  


errors = 
  PRODUCT_NOT_FOUND: 
    error: true
    message: "Not Found"
    code: 404
  BARCODE_REQUIRED:
    error: true
    message: "A barcode is required"
    code: 409
  PRODUCT_ALREADY_EXISTS:
    error: true
    message: "A product with the given barcode already exists"
    code: 409

