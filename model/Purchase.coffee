#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
#Item = require './Item'
Schema = mongoose.Schema
ObjectId = require('mongoose').Types.ObjectId

# This is the constructor for the Item Schema
module.exports = (db) ->

#	itemSchema = Item db
	
	ITEM = {
		productId: {type: String, required: true},
		price: {type: Number, required: true}
	}
	
	# This is the schema.  It's where we define what a user looks like
	PurchaseSchema = new Schema {
		userId: {type: String, required: true},
		storeId: {type: String, required: true},
		items: {type: [ITEM], required: true},
		total: {type: Number, required: true},
		purchaseDate: {type: Date, default: Date.now}
	}

	# This exports the schema
	Purchase = db.model "Purchase", PurchaseSchema
