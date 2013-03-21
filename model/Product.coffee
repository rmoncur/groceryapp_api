#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = require('mongoose').Types.ObjectId

# This is the constructor for the Schema
module.exports = (db) ->

	# This is the schema.  It's where we define what a product looks like
	ProductSchema = new Schema {
		user_id: String,
		name: String,
		size: { 
			amount: Number,
			unit: String
		},
		description: String,
		barcode: String,
#		tags: [TAG],
#		accounts: [ACCOUNT],
		last_update: Date
	}
	
	ProductSchema.statics.getProduct = (barcode, cb)->
    @findOne({"barcode": barcode}).exec cb
    
  ProductSchema.statics.getProductById = (product_id, cb) ->
    product_id = new ObjectId(product_id)
    @findOne("_id" : product_id).exec cb

	# This exports the schema
	Product = db.model "Product", ProductSchema
