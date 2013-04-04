# Product Endpoints
###### Notes:
This Document is intended to be comprehensive. It is to
be used as an API development guide as well as a client implementation guide.
If there is a deficiency in either respect, make sure it is brought to our
attention so that the documentation can be amended BEFORE any work is done to
fix the deficiency.

## Navigation
* [Products](#products)
	* [Create](#create) - **POST** /products	
	* [Read](#read) - **GET** /products/:barcode
	* [Update](#update) - **PUT** /products/:product_id
    * [Search](#update) - **GET** /products?query=search_query


## Products

#### Create

    POST /products

###### Example Request:
    {
        "barcode": "046813279202",                    //required
        "name": "Viva 2% Milk",                       //required
        "user_id": "651651651651651651",              //required
        "size": {                                     //optional (but highly suggested)
          "amount": 1,
          "units": "gallons"	
        }
        "description": "Some description about milk", //optional
        
        "price":1.53,                                 //optional (required with store_id to create an "item")
        "store_id":"12351236123r23",                  //optional (required with price to create an "item")
        "purchased":true                              //optional (required with price and store_id to create an "item")
    }
###### Expected Result:
    {
        "product": {
            "lastUpdate": "2013-02-16T21:50:19.882Z",
            "name": "Viva 2% Milk",
            "description": "Some description about milk",
            "barcode": "046813279202",
            "size": {
              	amount:"1",
              	units:"gallons"
            }
            "product_id": "511fff1b72bc612821000002"
        },
        "item": {
          "date": "2013-03-30T03:10:42.280Z",
          "item_id": "515657b2f998fe2a6c00003c",
          "price": 1.53,
          "product_id": "511fff1b72bc612821000002",
          "purchased": true,
          "store_id": "12351236123r23",
          "user_id": " uTHL3EiTfrKhzhOrCHs1NAq"
        }
    }
###### Error codes: 
    404 Not Found
    {
        "error": true,
        "message": "Not found"
    }
    
    409 Conflict
    {
        "error": true,
        "message": "A barcode is required"
    }


#### Read

    GET /products/:barcode

###### Example Request:
    /products/046813279202
###### Expected Result:
    {
        "lastUpdate": "2013-02-16T21:50:19.882Z",
        "name": "Viva 2% Milk",
        "description": "Some description about milk",
        "barcode": "046813279202",
        "size": {
        	amount:"1",
        	units:"gallons"
        }
        "product_id": "511fff1b72bc612821000002"
    }
###### Error codes:
    404 Not Found
    {
        "error": true,
        "message": "Not found"
    }

#### Update

    PUT /products/:product_id

###### Example Request:
    /products/511fff1b72bc612821000002
    {
	"barcode": "100", 		//optional
	"name": "Mtn Dairy 1% Milk", 	//optional
	"size": {			//optional
        	amount:"1",
        	units:"gallons"
        }
        "description": "Delicious Mountain Dairy Milk" 	//optional
    }
###### Expected Result:
    {
        "lastUpdate": "2013-02-16T21:50:19.882Z",
        "barcode": "100",
        "name": "Mtn Dairy 1% Milk", 		
        "size": {
        	amount:"1",
        	units:"gallons"
        } 			
        "description": "Delicious Mountain Dairy Milk",
        "product_id": "511fff1b72bc612821000002"
    } 
###### Error codes:
    404 Not Found
    {
        "error": true,
        "message": "Not found"
    }

#### Search

    GET /products/?{parameters}

###### Example Request:
    /products?query=chicken
    
###### Expected Result:
	[
		{
			"product_id":"asdfasdfasdf45y45",
			"barcode": "123412341234",
			"name": "Chicken Breasts",
			"size": {
				amount:"1",
				units:"gallons"
			},
			"description": "Delicious chicken breasts",
			"img":"http://images.com/img/124123523523623.jpg
			"pricedata": {
				"high":2.45,	
				"low":1.45,
				"avg":1.95,
				"median":1.85,
				"numscans":24,	//the number of times the product has been scanned, reported, etc.
			}
		},
		{
			"name": "Chicken pot pie",
			...
		}
		...
	]
###### Error codes:
    404 Not Found
    {
        "error": true,
        "message": "Not found"
    }

