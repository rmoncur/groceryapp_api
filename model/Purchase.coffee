#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema

# This is the constructor for the Item Schema
module.exports = (db) ->

	# This is the schema.  It's where we define what a user looks like
	PurchaseSchema = new Schema {
		purchaseID: String,
		userID: String,
		storeID: String,
		items: [Item];
		total: String;
		purchaseDate: String;
	}

	# This exports the schema
	Purchase = db.model "Purchase", PurchaseSchema