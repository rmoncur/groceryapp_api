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

#This is the User model object.  It will handle putting stuff into the database
#and will be used mainly by the UserController.
User = require './model/User'

#This is creating URI to the database
DB = process.env.DB || 'mongodb://localhost:27017/grocery'

#This is creating a connection to the database
db = Mongoose.createConnection DB
user = User db
userController = UserController user

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
    
    app.use(app.router)
    app.use(express.static(__dirname + "/public"))


  #This is a simple endpoint that just returns a fake user
  app.get '/users/:user_id', (req, res) ->
    res.json {user: "Casey Moncur"}

  #This is the post endpoint where users will be created
  app.post '/users', (req, res) ->
    res.json {success: true, code: 201}

  #This is the put endpoint where users will be updated
  app.put '/users/:user_id', (req, res) ->
    res.json {success: true, code: 200}

  #This is the delete endpoint where users will be deleted
  app.delete '/users/:user_id', (req, res) ->
    res.json {success: true, code: 200}

  # final return of app object
  # in coffeescript everything always returns a value, and functions return the last value computed.
  # so we don't really need to use the return keyword
  app

#This is where we really start our server
if module == require.main
  app = exports.createServer()
  app.listen 8080 #This is the port we are listening on.
  console.log "Running Grocery App Service" #This is just some output to show that the server is working

