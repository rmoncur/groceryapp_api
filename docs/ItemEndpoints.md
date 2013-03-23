# Product Endpoints
###### Notes:
This Document is intended to be comprehensive. It is to
be used as an API development guide as well as a client implementation guide.
If there is a deficiency in either respect, make sure it is brought to our
attention so that the documentation can be amended BEFORE any work is done to
fix the deficiency.

## Navigation
* [Items](#items)
  * [Create](#create) - **POST** /items
  * [Read](#read) - **GET** /items/:item_id
  * [Update](#update) - **PUT** /items/:item_id


## items

#### Create

    POST /items

###### Example Request:
    {
        "price": 12.3,                                //required
        "product_id": "111111111111111111111111",     //required
        "store_id": "222222222222222222222222",       //required
        "user_id": "333333333333333333333333",        //required
        "purchased": true,                            //optional; default = false
        "date": "2013-03-17T06:00:00.000Z"            //optional; default = now; any standard date format that specifies timezone
    }
###### Expected Result:
    201 Created
    {
        "item_id": "444444444444444444444444",
        "price": 12.3,
        "product_id": "111111111111111111111111",
        "store_id": "222222222222222222222222",
        "user_id": "333333333333333333333333",
        "purchased": true,
        "date": "2013-03-17T06:00:00.000Z"
    }
###### Error codes: 
    409 Conflict
    {
        "error": true,
        "message": "required fields missing",
        "fields": ['price', 'store_id', ...]    //array of missing fields
    }


#### Read

    GET /items/:item_id

###### Expected Result:
    200 OK
    {
        "item_id": "444444444444444444444444",
        "price": 12.3,
        "product_id": "111111111111111111111111",
        "store_id": "222222222222222222222222",
        "user_id": "333333333333333333333333",
        "purchased": true,
        "date": "2013-03-17T06:00:00.000Z"
    }
###### Error codes:
    404 Not Found
    {
        "error": true,
        "message": "Item not found"
    }

#### Update

    PUT /items/:item_id

###### Example Request:
    /items/444444444444444444444444
    {
        "price": 12.3,                                      //optional
        "product_id": "111111111111111111111111",           //optional
        "store_id": "222222222222222222222222",             //optional
        "purchased": true,                                  //optional
        "date": "2013-03-17T06:00:00.000Z"                  //optional
    }
###### Expected Result:
    {
        "item_id": "444444444444444444444444",
        "price": 12.3,
        "product_id": "111111111111111111111111",
        "store_id": "222222222222222222222222",
        "user_id": "333333333333333333333333",
        "purchased": true,
        "date": "2013-03-17T06:00:00.000Z"
    }
###### Error codes:
    404 Not Found
    {
        "error": true,
        "message": "Not found"
    }

    409 Conflict
    {
        
    }
