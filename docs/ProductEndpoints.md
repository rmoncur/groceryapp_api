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


## Products

#### Create

    POST /products

###### Example Request:
    {
        "barcode": "046813279202", 						//required
        "name": "Viva 2% Milk", 						//optional
        "size": "1 Gallon", 							//optional
        "description": "Some description about milk" 	//optional
    }
###### Expected Result:
    {
        "__v": 0,
        "lastUpdate": "2013-02-16T21:50:19.882Z",
        "name": "Viva 2% Milk",
        "description": "Some description about milk",
        "barcode": "046813279202",
        "size": "1 Gallon",
        "_id": "511fff1b72bc612821000002"
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
        "__v": 0,
        "lastUpdate": "2013-02-16T21:50:19.882Z",
        "name": "Viva 2% Milk",
        "description": "Some description about milk",
        "barcode": "046813279202",
        "size": "1 Gallon",
        "_id": "511fff1b72bc612821000002"
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
        "barcode": "100", 								//optional
        "name": "Mtn Dairy 1% Milk", 					//optional
        "size": "1 Gal", 								//optional
        "description": "Delicious Mountain Dairy Milk" 	//optional
    }
###### Expected Result:
    {
        "__v": 0,
        "lastUpdate": "2013-02-16T21:50:19.882Z",
        "barcode": "100",
        "name": "Mtn Dairy 1% Milk", 		
        "size": "1 Gal", 			
        "description": "Delicious Mountain Dairy Milk",
        "_id": "511fff1b72bc612821000002"
    } 
###### Error codes:
    404 Not Found
    {
        "error": true,
        "message": "Not found"
    }
