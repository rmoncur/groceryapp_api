#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema

# This is the constructor for the Item Schema
module.exports = (db) ->

	# This is the schema.  It's where we define what a user looks like
	ProductSchema = new Schema {
		productID: String,
		userID: String,
		name: String,
		quantity: String,
		description: String,
		barcode: String,
		tags: [TAG]],
		accounts: [ACCOUNT],
		lastUpdate: String
	}

	# This exports the schema
	Product = db.model "Product", ProductSchema