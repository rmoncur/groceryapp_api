#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema

# This is the constructor for the Item Schema
module.exports = (db) ->

	# This is the schema.  It's where we define what a user looks like
	StoreSchema = new Schema {
		foursquareId: String,
		price: Float
	}

	# This exports the schema
	Item = db.model "Item", ItemSchema