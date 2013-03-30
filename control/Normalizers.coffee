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

  item: (item) =>
    result = {}
    for key in itemBase
      if key is "item_id" and item._id?
        result[key] = item._id
      else 
        result[key] = item[key]
    return result
    
  product: (product) =>
    result = {}
    fields = productBase
    for key in fields
      if key is 'product_id' and product._id?
        result[key] = product._id
      else if product[key]?
        result[key] = product[key]
    return result
