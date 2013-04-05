module.exports = () =>


  itemBase = [
    'price'
    'store_id'
    'item_id'
    'product_id'
    'user_id'
    'date'
    'purchased'
  ]
  
  productBase = [
    'product_id'
    'user_id'
    'name'
    'size'
    'points'
    'barcode'
    'last_update'
    'description'
  ]
  
  userBase = [
  	'user_id'
		'email'
		'token'
		'username'
		'points'
  ]
  
	tagBase = [
    'tag_id'
    'userId'
    'name'
    'category'
  ]
  
  normalize: (base, object, objectName) =>
  	result = {}
  	for key in base
  		if key is "#{objectName}_id" and object._id?
  			result[key] = object._id
			else
				result[key] = object[key]
		return result

  item: (item) =>
    normalize(itemBase, item, "item")
    
  product: (product) =>
    normalize(productBase, product, "product")

  user: (user) =>
  	normalize(userBase, user, "user")
  	result.img = 'http://www.gravatar.com/avatar/' + md5(result.email)
		result.level = getLevel(result.points)
		return result
	
	getLevel = (points)->
		return Math.floor(points/10)

	tag: (tag) =>
		normalize(tagBase, tag, "tag")








