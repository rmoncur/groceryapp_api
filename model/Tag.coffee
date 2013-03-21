#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = require('mongoose').Types.ObjectId

# This is the constructor for the Item Schema
module.exports = (db) ->

	TagSchema = new Schema {
		tagId: String,
		userId: String,
		name: String,
		relatedTags: [String],
		category: String,
		complimentTags: [String],
		lastUpdate: String
	}

	TagSchema.statics.getCategories = (user_id, cb) ->
		#@group(
		#	{key: { "category" : 1},
        #    $reduce: (curr,result) => {},
        #    initial: {}
        #    });

	TagSchema.statics.getTag = (tag_id, cb) ->
		console.log "Tag.getTag"
		console.log tag_id
		tag_id = new ObjectId(tag_id)
		@findOne({"tag_id" : tag_id}).exec cb

	TagSchema.statics.getTagsByUser = (user_id, cb) ->
		@find({ $or: [{ "userId" : user_id },{ "userId" : 0 }]}).exec cb

	TagSchema.statics.getTagsByCategory = (category, cb) ->
		console.log category
		@find({"cagetory" : category}).exec cb

	TagSchema.statics.searchTags = (search, cb) ->
		console.log search
		@findOne({"name" : search}).exec cb

	TagSchema.statics.deleteTagByUserId = (req, cb) ->
		console.log req
		@remove({"user_id" : user_id, "_id" : tag_id}).exec cb
	# This exports the schema
	Tag = db.model "Tag", TagSchema