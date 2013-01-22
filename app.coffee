express = require 'express'
fs = require 'fs'
MemoryStore = require('express').session.MemoryStore
Mongoose = require 'mongoose'
UserController = require './control/users'
User = require './model/User'


DB = process.env.DB || 'mongodb://localhost:27017/grocery'
db = Mongoose.createConnection DB
user = User db
userController = UserController user


exports.createServer = ->
  app = express.createServer()
  

  app.configure ->
    app.use(express.cookieParser())
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(express.session({ secret: 'keyboard cat' }))
    
    app.use(app.router)
    app.use(express.static(__dirname + "/public"))


  app.get '/', (req, res) ->
    res.json req.user

  # final return of app object
  app

if module == require.main
  app = exports.createServer()
  app.listen 8080
  console.log "Running Grocery App Service"

