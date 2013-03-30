#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = require('mongoose').Types.ObjectId

# This is the constructor for the Item Schema
module.exports = (db) ->

	# This is the schema.  It's where we define what a user looks like
	ItemSchema = new Schema {
		price: { type: Number, required: true, min: 0 },
		product_id: { type: String, required: true },
		user_id: { type: String, required: true },
		store_id: { type: String, required: true },
		date: { type: Date, default: Date.now },
		purchased: {type: Boolean, default: false },
		most_recent_for_store: {type: Boolean, default: true }
	}

	ItemSchema.statics.getItemById = (item_id, cb) ->
    item_id = new ObjectId(item_id)
    @findOne("_id" : item_id).exec cb
    
  ItemSchema.statics.getItemsByUserId = (user_id, cb) ->
  	@find("user_id" : user_id).exec cb
  	
	ItemSchema.statics.getMostRecentItemsByProductId = (product_id, cb) ->
		@find({"product_id" : product_id, "most_recent_for_store": true }).exec cb
		
	ItemSchema.statics.updateMostRecentItem = (item) ->
		item_id = new ObjectId(item._id.toString())
		@update({"store_id": item.store_id, "_id": { $ne : item_id } }, { most_recent_for_store: false }, { multi: true }).exec()

	# This exports the schema
	Item = db.model "Item", ItemSchema
