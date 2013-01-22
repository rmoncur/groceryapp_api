mongoose = require 'mongoose'
Schema = mongoose.Schema

# User Model
module.exports = (db) ->

  UserSchema = new Schema {
    name: {familyName: String, givenName: String}
  }




  User = db.model "User", UserSchema