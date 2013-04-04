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
		purchased: {type: Boolean, default: false }
	}

	ItemSchema.statics.getItemById = (item_id, cb) ->
    item_id = new ObjectId(item_id)
    @findOne("_id" : item_id).exec cb
    
  ItemSchema.statics.getItemsByUserId = (user_id, cb) ->
  	@find("user_id" : user_id).exec cb

	# This exports the schema
	Item = db.model "Item", ItemSchema
