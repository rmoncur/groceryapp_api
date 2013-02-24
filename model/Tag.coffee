#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema

# This is the constructor for the Item Schema
module.exports = (db) ->

	TagSchema = new Schema {
		tagId: String,
		userId: String,
		name: String,
		relatedTags: [Tag],
		parentTags: [Tag],
		complimentTags: [Tag],
		lastUpdate: String
	}

	# This exports the schema
	Tag = db.model "Tag", TagSchema