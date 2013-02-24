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

#This is the User model object.  It will handle putting stuff into the database
#and will be used mainly by the UserController.
UserModel = require './model/User'
TagModel = require './model/Tag'
PurchaseModel = require './model/Purchase'
ProductModel = require './model/Product'

mongomate = require("mongomate")('mongodb://localhost')

#This is creating URI to the database
DB = process.env.DB || 'mongodb://localhost:27017/grocery'

#This is creating a connection to the database
db = Mongoose.createConnection DB

User = UserModel db
UserController = UserControllerModel User

Tag = TagModel db
TagController = TagControllerModel Tag

Product = ProductModel db
ProductController = ProductControllerModel Product

Purchase = PurchaseModel db
PurchaseController = PurchaseControllerModel Purchase

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
    UserController.authenticateUser req, res, (user)=>
      UserController.getUser req, res
  
  #This is the post endpoint where users will be created
  app.post '/users', (req, res) ->
    UserController.createUser req, res

  app.post '/users/login', (req, res) ->
    UserController.login req, res

  #This is the put endpoint where users will be updated
  app.put '/users/:user_id', (req, res) ->
    res.json {success: true, code: 200}

  #This is the delete endpoint where users will be deleted
  app.delete '/users/:user_id', (req, res) ->
    UserController.authenticateUser req, res, (user)=>
      UserController.deleteUser req, res

  ### Tag Endpoints ###
  #Get all Tags and those associated with the user_id
  app.get '/tags/:user_id', (req, res) ->
    TagController.getTags req, res

  #Post endpoint for creating new tags
  app.post '/tags' , (req, res) ->
    TagController.createTag req, res

  #Put endpoint for updating tags
  app.put '/tags/:user_id', (req, res) ->
    res.json {success: true, code: 200}

  #Delete endpoint for deleting tags
  app.delete '/tags/:user_id', (req, res) ->
    TagController.deleteTag req, res

  
  # PRODUCTS #
  app.get '/products/:barcode', (req, res) ->
    ProductController.getProduct req, res

  app.post '/products', (req, res) -> 
    console.log req.body
    ProductController.createProduct req, res

  app.put '/products/:product_id', (req, res) ->
    ProductController.updateProduct req, res
    
    
  # PURCHASES #
  app.post '/purchases', (req, res) ->
    PurchaseController.createPurchase req, res
    
  app.get '/purchases/:user_id', (req, res) ->
    PurchaseController.getPurchasesForUser req, res
    
  app.delete '/purchases/:purchase_id', (req, res) ->
    PurchaseController.deletePurchase req, res
    
  app.put '/purchases/:purchase_id', (req, res) ->
    PurchaseController.updatePurchase req, res

  # final return of app object
  # in coffeescript everything always returns a value, and functions return the last value computed.
  # so we don't really need to use the return keyword
  app

#This is where we really start our server
if module == require.main
  PORT = 80
  app = exports.createServer()
  app.listen PORT #This is the port we are listening on.
  console.log "Running Grocery App Service on port: " + PORT #This is just some output to show that the server is working
