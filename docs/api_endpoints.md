# API Endpoints
###### Notes:
This Document is intended to be comprehensive. It is to
be used as an API development guide as well as a client implementation guide.
If there is a deficiency in either respect, make sure it is brought to our
attention so that the documentation can be amended BEFORE any work is done to
fix the deficiency.

## Navigation
* [Users](#users)
	* [Create](#create) - **POST** /users
	* [Read](#read) - **GET** /users/:user_id
	* [Update](#update) - **PUT** /users/:user_id
	* [Delete](#delete) - **DEL** /users/:user_id
* [Products](#products)
	* [Create](#create-1) - **POST** /products	
	* [Read](#read-1) - **GET** /products/:barcode
	* [Update](#update-1) - **PUT** /products/:product_id


## Users

#### Create

    POST /users

###### Example Request:
{
	"email": "caseymonc@gmail.com",
	"password": "p@ssw0rd"
}
###### Expected Result:
{
	"email" : "caseymonc@gmail.com",
	"user_id": "afffe332234222",
	"token": "adba0d-eee4535-345252-abc4434"
}
###### Error codes: <!-- TODO -->


#### Read

    GET /users/:user_id?token=adba0d-eee4535-345252-abc4434

###### Example Request:
###### Expected Result:
{
	"email" : "caseymonc@gmail.com",
	"user_id": "afffe332234222",
	"token": "adba0d-eee4535-345252-abc4434"
}
###### Error codes: <!-- TODO -->


#### Update

    PUT /users/:user_id

###### Example Request: <!-- TODO -->
###### Expected Result: <!-- TODO -->
###### Error codes: <!-- TODO -->


#### Delete

    DEL /users/:user_id

###### Example Request:
{
	"user_id": "afffe332234222",
	"token": "adba0d-eee4535-345252-abc4434"
}
###### Expected Result:
{
	"message": "deleted"
}
###### Error codes: <!-- TODO -->

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

