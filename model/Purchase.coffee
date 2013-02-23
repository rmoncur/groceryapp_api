#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
#Item = require './Item'
Schema = mongoose.Schema
ObjectId = require('mongoose').Types.ObjectId

# This is the constructor for the Item Schema
module.exports = (db) ->

#	itemSchema = Item db
	
	ITEM = {
		productId: String,
		price: Number
	}
	
	# This is the schema.  It's where we define what a user looks like
	PurchaseSchema = new Schema {
		userId: String,
		storeId: String,
		items: [ITEM],
		total: Number,
		purchaseDate: {type: Date, default: Date.now}
	}

	# This exports the schema
	Purchase = db.model "Purchase", PurchaseSchema
