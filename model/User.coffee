
#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = require('mongoose').Types.ObjectId

# This is the constructor for the User Schema
# Every function inside of this function can be called when dealing with a user object
# User Model
module.exports = (db) ->

	# This variable will be in the schema.
	# Just pulled it out to make things more readable
	ACCOUNT = {
		store_id: String,
		account_number: String
	}

	# This is the schema.  It's where we define what a user looks like
	UserSchema = new Schema {
		username: String,
		email: String,
		password: String,
		accounts: [ACCOUNT],
		token: String,
		points: Number
	}

	UserSchema.statics.getUser = (email, cb)->
		@findOne({"email": email}).exec cb

	UserSchema.statics.getUserById = (user_id, cb)->
		user_id = new ObjectId(user_id)
		console.log user_id
		@find("_id" : user_id).exec cb

	UserSchema.statics.deleteUserById = (user_id, cb)->
		user_id = new ObjectId(user_id)
		console.log user_id
		@remove({"_id" : user_id}).exec cb

	# This exports the schema
	User = db.model "User", UserSchema