#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = require('mongoose').Types.ObjectId

# This is the constructor for the Item Schema
module.exports = (db) ->

	
	ITEM = {
		product_id: {type: String, required: true},
		price: {type: Number, required: true}
	}
	
	# This is the schema.  It's where we define what a user looks like
	PurchaseSchema = new Schema {
		user_id: {type: String, required: true},
		store_id: {type: String, required: true},
		items: {type: [ITEM], required: true},
		total: {type: Number, required: true},
		purchaseDate: {type: Date, default: Date.now}
	}

	PurchaseSchema.statics.getPurchasesForUser = (user_id, cb) ->
#		user_id = new ObjectId user_id
		@find({ "user_id": user_id }).exec cb

	PurchaseSchema.statics.deletePurchase = (purchase_id, cb) ->
		purchase_id = new ObjectId purchase_id
		@remove({ "_id": purchase_id}).exec cb

	# This exports the schema
	Purchase = db.model "Purchase", PurchaseSchema
