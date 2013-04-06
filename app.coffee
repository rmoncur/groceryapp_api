###
  How to run the server
  1. install node
  2. run npm install
  3. run coffee ./app.coffee
###

#Express is a module that helps with making the server.  
#It handles GETs, POSTs etc, as well as parsing data that is sent in said requests
express = require 'express'

#Mongoose is a module that helps manage MongoDB databases.  
#It helps to create schemas which define attributes (columns) in documnts (tables).
#Basically, it helps us to keep the data we put into the database in a format that makes sense.
Mongoose = require 'mongoose'

#This is an example of importing one of our own files.
#I am importing the UserController which I will then call
#Methods on as I receive requests that pertain to the /users URI
UserControllerModel = require './control/UserController'
TagControllerModel = require './control/TagController'
PurchaseControllerModel = require './control/PurchaseController'
ProductControllerModel = require './control/ProductController'
ItemControllerModel = require './control/ItemController'
SubscriberControllerModel = require './control/SubscriberController'

#This is the User model object.  It will handle putting stuff into the database
#and will be used mainly by the UserController.
UserModel = require './model/User' #grab user file "object"
TagModel = require './model/Tag'
PurchaseModel = require './model/Purchase'
ProductModel = require './model/Product'
ItemModel = require './model/Item'
SubscriberModel = require './model/Subscriber'

mongomate = require("mongomate")('mongodb://localhost')

#This is creating URI to the database
DB = process.env.DB || 'mongodb://localhost:27017/grocery'

#This is creating a connection to the database
db = Mongoose.createConnection DB

Item = ItemModel db
User = UserModel db # create user class.
UserController = UserControllerModel User, Item #pass class into controller so that we can use the class in the controller

Tag = TagModel db
TagController = TagControllerModel Tag

Product = ProductModel db
ProductController = ProductControllerModel Product, Item

Purchase = PurchaseModel db
PurchaseController = PurchaseControllerModel Purchase

ItemController = ItemControllerModel Item

StoresController = require('./control/StoresController')()

Subscriber = SubscriberModel db
SubscriberController = SubscriberControllerModel Subscriber

AmazonUPCCotroller = require('./control/AmazonUPCController')()

# This is the function that creates the server.
# We will define endpoints and connect them up to 
# controllers here.
exports.createServer = ->
  #This creates a server from the express object
  app = express.createServer()
  

  #This configures the server to parse the requests correctly and use sessions
  app.configure ->
    app.use(express.cookieParser())
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(express.session({ secret: 'keyboard cat' }))
    app.use('/db', mongomate);
    app.use(app.router)
    app.use(express.static(__dirname + "/public"))


  app.get '/users/auth/:user_id', (req, res) ->
    data = {user_id: req.query.user_id, token: req.query.token}
    UserController.authenticateUser data, res, (user)=>
      res.json user

  ### User Endpoints ###
  
  #GET endpoint for getting user by user_id
  app.get '/users/:user_id', (req, res) ->
    console.log req.body.user_id
    UserController.authenticateUser req, res, (user)=>
      UserController.getUser req, res
  
  #This is the post endpoint where users will be created
  app.post '/users', (req, res) ->
    UserController.createUser req, res

  app.post '/users/login', (req, res) ->
    console.log req.body
    UserController.login req, res

  #This is the put endpoint where users will be updated
  app.put '/users/:user_id', (req, res) ->
    res.json {success: true, code: 200}

  #This is the delete endpoint where users will be deleted
  app.delete '/users/:user_id', (req, res) ->
    UserController.authenticateUser req, res, (user)=>
      UserController.deleteUser req, res

  app.get '/users/:user_id/purchases', (req, res) ->
    PurchaseController.getPurchasesForUser req, res

  ### Tag Endpoints ###

  #Get all Tags and those associated with the user_id
  app.get '/users/:user_id/tags/', (req, res) ->
    UserController.authenticateUser req, res, (user)=>
      console.log req.params
      console.log req.query
      if req.query.category_id
        TagController.getTagsByCategory req, res
      else if req.query.search
        TagController.searchTags req, res
      else if req.query.tag_id
        TagController.getTag req, res
      else
        TagController.getTagsByUser req, res

  #Get all Categories
  app.get '/users/:user_id/tags/categories/', (req, res) ->
    TagController.getCategories req, res
  
  #Get all Tags in a Category
  #app.get '/users/:user_id/tags/?category_id=category_id', (req, res) ->
  #  TagController.getTagsByCategory req, res
  
  #Search for Tags
  app.get '/users/:user_id/tags/?search=search_string', (req, res) ->
    TagController.searchTags req, res
  
  #Get Tag
  app.get '/users/:user_id/tags/?tag_id=tag_id', (req, res) ->
    TagController.getTag req, res
  
  #Post endpoint for creating new tags
  app.post '/users/:user_id/tags' , (req, res) ->
    TagController.createTag req, res

  #Put endpoint for updating tags
  app.put '/users/:user_id/tags/:tag_id', (req, res) ->
    res.json {success: true, code: 200}

  #Delete endpoint for deleting tags
  app.delete '/users/:user_id/tags/:tag_id', (req, res) ->
    TagController.deleteTag req, res

  
  ### PRODUCTS ###
  app.get '/products', (req, res) ->
    return ProductController.getProductByBarcode req, res if req.query?.barcode?
    ProductController.getProducts req, res

  app.get '/products/:product_id', (req, res) ->
    ProductController.getProduct req, res

#  app.get '/products', (req, res) ->
#    ProductController.getProductByBarcode req, res

  app.post '/products', (req, res) -> 
    console.log req.body
    ProductController.createProduct req, res

  app.put '/products/:product_id', (req, res) ->
    ProductController.updateProduct req, res
    
    
  ### PURCHASES ###
  app.post '/purchases', (req, res) ->
    PurchaseController.createPurchase req, res
    
  app.get '/purchases/:purchase_id', (req, res) ->
    PurchaseController.getPurchase req, res
    
  app.delete '/purchases/:purchase_id', (req, res) ->
    PurchaseController.deletePurchase req, res
    
  app.put '/purchases/:purchase_id', (req, res) ->
    PurchaseController.updatePurchase req, res
    
  # ITEMS #
  app.post '/items', (req, res) ->
    ItemController.createItem req, res

  app.get '/items/:item_id', (req, res) ->
    ItemController.getItem req, res
    
  app.put '/items/:item_id', (req, res) ->
    ItemController.updateItem req, res

  app.get '/users/:user_id/items', (req, res) ->
    UserController.getItems req, res

  # STORES #
  app.get '/stores/nearby', (req, res)->
    StoresController.getNearbyStores req, res

  app.get '/stores/closest', (req, res)->
    StoresController.getClosestStore req, res

  app.get '/stores/here', (req, res)->
    StoresController.getAtTheStore req, res

  app.get '/stores/my', (req, res)->
    StoreController.getMyStores req, res


  app.get '/lookup/:upc', (req, res)->
    AmazonUPCCotroller.getItemByBarcode req.params.upc, (err, result)->
      return res.send err if err?
      return res.send result if result
      res.send {err: "Not found"}


  app.post '/event/register', (req, res)->
    SubscriberController.addSubscriber req, res

  app.delete '/event/register', (req, res)->
    SubscriberController.removeSubscriber req, res


  # final return of app object
  # in coffeescript everything always returns a value, and functions return the last value computed.
  # so we don't really need to use the return keyword
  app

#This is where we really start our server
if module == require.main
  PORT = 8000
  app = exports.createServer()
  app.listen PORT #This is the port we are listening on.
  console.log "Running Grocery App Service on port: " + PORT #This is just some output to show that the server is working
