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
UserController = require './control/users'
ProductController = require './control/products'
PurchaseController = require './control/purchases'

#This is the User model object.  It will handle putting stuff into the database
#and will be used mainly by the UserController.
User = require './model/User'
Product = require './model/Product'
Purchase = require './model/Purchase'
#Item = require './model/Item'

mongomate = require("mongomate")('mongodb://localhost')

#This is creating URI to the database
DB = process.env.DB || 'mongodb://localhost:27017/grocery'

#This is creating a connection to the database
db = Mongoose.createConnection DB
user = User db
userController = UserController user
product = Product db
productController = ProductController product
purchase = Purchase db
purchaseController = PurchaseController purchase
#item = Item db

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
		userController.authenticateUser data, res, (user)=>
			res.json user

  #This is a simple endpoint that just returns a fake user
	app.get '/users/:user_id', (req, res) ->
		userController.authenticateUser req, res, (user)=>
			userController.getUser req, res
  
	app.get '/leckie/', (req, res) ->
		res.json {user: "Leckie Gunter"}

  #This is the post endpoint where users will be created
	app.post '/users', (req, res) ->
		userController.createUser req, res

  #This is the put endpoint where users will be updated
	app.put '/users/:user_id', (req, res) ->
		res.json {success: true, code: 200}

  #This is the delete endpoint where users will be deleted
	app.delete '/users/:user_id', (req, res) ->
		userController.authenticateUser req, res, (user)=>
			userController.deleteUser req, res


  # PRODUCTS #
	app.get '/products/:barcode', (req, res) ->
		productController.getProduct req, res

	app.post '/products', (req, res) -> 
		console.log req.body
		productController.createProduct req, res

	app.put '/products/:product_id', (req, res) ->
		productController.updateProduct req, res
    
    
  # PURCHASES #
	app.post '/purchases', (req, res) ->	
		console.log req.body
		purchaseController.createPurchase req, res

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
