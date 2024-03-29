# Purchase Endpoints
###### Notes:
This Document is intended to be comprehensive. It is to
be used as an API development guide as well as a client implementation guide.
If there is a deficiency in either respect, make sure it is brought to our
attention so that the documentation can be amended BEFORE any work is done to
fix the deficiency.

## Navigation
* [Purchases](#purchases)
    * [Create](#create) - **POST** /purchases
    * [Read](#read) - **GET** /purchases/:product_id
    * [Read](#read-1) - **GET** /users/:user_id/purchases
    * [Update](#update) - **PUT** /products/:product_id
    * [Delete](#delete) - **DELETE** /products/:product_id


## Purchases

#### Create

    POST /purchases

###### Example Request:
    {
        "user_id": "3",                     //required
        "store_id": "2",                    //required
        "items": [{                         //optional
            "product_id": "3",              //required
            "price": 12.30                  //required
        }],
        "total": 13.07,                     //required
        "purchaseDate": "05/30/2012"        //optional, defaults to now
    }
###### Expected Result:
    {
        "__v": 0,
        "user_id": "3",
        "store_id": "2",
        "total": 13.07,
        "_id": "5132bf08a3a87f9724000007",
        "purchaseDate": "2012-05-30T17:12:13.000Z",
        "items": [
            {
                "product_id": "3",
                "price": 12.3,
                "_id": "5132bf08a3a87f9724000008"
            }
        ]
    }
###### Error codes: 
    404 Not Found
    {
        "error": true,
        "message": "User Not found"
    }
    
    404 Not Found
    {
        "error": true,
        "message": "Store Not Found"
    }
    
    404 Not Found
    {
        "error": true,
        "message": "Product Not Found"
    }


#### Read

    GET /purchases/:purchase_id

###### Example Request:
    /purchases/5132b83af9d6494b23000003
###### Expected Result:
    {
        "user_id": "3",
        "store_id": "2",
        "total": 13.07,
        "_id": "5132bf08a3a87f9724000007",
        "__v": 0,
        "purchaseDate": "2012-05-30T17:12:13.000Z",
        "items": [
            {
                "product_id": "3",
                "price": 12.3,
                "_id": "5132bf08a3a87f9724000008"
            }
        ]
    }
###### Error codes:
    404 Not Found
    {
        "error": true,
        "message": "Purchase Not found"
    }

#### Read

    GET /users/:user_id/purchases

###### Example Request:
    /users/3/purchases
###### Expected Result:
    [
        {
            "user_id": "3",
            "store_id": "2",
            "total": 13.07,
            "_id": "512943d8773f6d881b00000a",
            "__v": 0,
            "purchaseDate": "2013-02-23T22:34:00.758Z",
            "items": [
                {
                    "product_id": "3",
                    "price": 12.3,
                    "_id": "512943d8773f6d881b00000b"
                }
            ]
        },
        {
            "user_id": "3",
            "store_id": "2",
            "total": 13.07,
            "_id": "512943dc773f6d881b00000c",
            "__v": 0,
            "purchaseDate": "2013-02-23T22:34:04.468Z",
            "items": [
                {
                    "product_id": "3",
                    "price": 12.3,
                    "_id": "512943dc773f6d881b00000d"
                }
            ]
        }
    ]
###### Error codes:
    404 Not Found
    {
        "error": true,
        "message": "User Not found"
    }

#### Update

    PUT /purchases/:purchase_id

###### Example Request:
    /purchases/5132b83af9d6494b23000003
    {
        "user_id": "3",                             //optional
        "store_id": "2",                            //optional
        "total": 13.07,                             //optional
        "purchaseDate": "October 17, 1999"          //optional
    }
###### Expected Result:
    {
        "user_id": "3",
        "store_id": "2",
        "total": 13.07,
        "_id": "5132b83af9d6494b23000003",
        "__v": 0,
        "purchaseDate": "1999-10-17T06:00:00.000Z",
        "items": [
            {
                "product_id": "3",
                "price": 12.3,
                "_id": "5132b83af9d6494b23000004"
            }
        ]
    }
###### Error codes:
    404 Not Found
    {
        "error": true,
        "message": "Purchase Not found"
    }
    
    404 Not Found
    {
        "error": true,
        "message": "User Not found"
    }
    
    404 Not Found
    {
        "error": true,
        "message": "Store Not Found"
    }
    
    404 Not Found
    {
        "error": true,
        "message": "Product Not Found"
    }

