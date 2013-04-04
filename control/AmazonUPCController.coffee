OperationHelper = require('apac').OperationHelper

ACCESS_KEY_ID = "AKIAJTWQEUQMCRQG553A"
ACCESS_KEY = "xn4DQnHqszSkNa/GN943I9pan7JHcgl9qdbiT1Zj"
ASSOCIATE_ID = "grocetrack-20"

module.exports = () =>
	getItemByBarcode: (barcode, cb)=>
		opHelper = new OperationHelper({awsId: ACCESS_KEY_ID, awsSecret: ACCESS_KEY, assocId: ASSOCIATE_ID })
		opHelper.execute 'ItemLookup', {IdType: 'EAN', ItemId: barcode, SearchIndex: 'Grocery', TruncateReviewsAt: 0, ResponseGroup: "Images,Offers,PromotionSummary,ItemAttributes"}, (err, result)=>
			return cb err if err?
			return cb null, result