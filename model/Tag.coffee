#Require Mongoose so that we can use schemas
mongoose = require 'mongoose'
Schema = mongoose.Schema

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
		#	{key: { "category":true},
        #    reduce: function(obj,prev) { prev.count += 1; },
        #    initial: { count: 0 }
        #    });

	TagSchema.statics.getTag = (name, cb) ->
		@find("name" : name).exec cb

	TagSchema.statics.getTagsByUser = (user_id, cb) ->
		user_id = new ObjectId(user_id)
		console.log user_id
		@find("user_id" : user_id).exec (tags, cb) ->
			#TODO Add prev tags to the new find from general tags
			@find('user_id' : 0).exec cb

	TagSchema.statics.getTagsByCategory = (category, cb) ->
		@find("cagetory" : category).exec cb

	TagSchema.statics.getAllTags = (user_id, cb) ->
		@find("user_id" : 0).exec cb

	TagSchema.statics.deleteTagByUserId = (user_id, cb) ->
		user_id = new ObjectId(user_id)
		console.log user_id
		@remove("user_id" : user_id).exec cb
	# This exports the schema
	Tag = db.model "Tag", TagSchema