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
	* [Login](#create) - **POST** /users
	* [Read](#read) - **GET** /users/:user_id
	* [Update](#update) - **PUT** /users/:user_id
	* [Delete](#delete) - **DEL** /users/:user_id
	
	* Read - **GET** /users/:user_id/purchases (see Purchase Endpoints.md)
	* [Read](#read-1) - **GET** /users/:user_id/items


## Users

#### Create

    POST /users

###### Example Request:
{
	"email": "caseymonc@gmail.com",
	"password": "p@ssw0rd",
	"username": "caseymonc"
}
###### Expected Result:
{
    "email": "casey@i.tv",
    "token": "4907a3c8-4181-4337-993c-4f482c908378-d63-3b-167c5c0787",
    "username": "caseymonc",
    "points": 0,
    "user_id": "514b82b8137ff3ed63000003"
}
###### Error codes: <!-- TODO -->


#### Login

    POST /users/login

###### Example Request:
{
	"email": "caseymonc@gmail.com",
	"password": "p@ssw0rd"
}
###### Expected Result:
{
    "email": "casey@i.tv",
    "token": "de5f10ca-1cd9-419a-815a-8ea7403d11e8-ab5-e8-48b3684bec",
    "username": "caseymonc",
    "points": 0,
    "user_id": "512fd7f3483483cb0c000003"
}
###### Error codes: <!-- TODO -->


#### Read

    GET /users/:user_id?token=adba0d-eee4535-345252-abc4434

###### Example Request:
###### Expected Result:
{
    "email": "casey@i.tv",
    "token": "de5f10ca-1cd9-419a-815a-8ea7403d11e8-ab5-e8-48b3684bec",
    "username": "caseymonc",
    "points": 0,
    "user_id": "512fd7f3483483cb0c000003"
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


#### Read

    GET /users/:user_id/items  Get all items that a user has reported

###### Example Request:
###### Expected Result:
    200
    [
      {
        "price": 43,
        "store_id": "444444444444444444444444",
        "item_id": "555555555555555555555555",
        "product_id": "666666666666666666666666",
        "user_id": "777777777777777777777777",
        "date": "2013-03-30T14:53:38.530Z", 
        "purchased": false
      },
      {
        "price": 43,
        "store_id": "444444444444444444444444",
        "item_id": "999999999999999999999999",
        "product_id": "888888888888888888888888",
        "user_id": "777777777777777777777777",
        "date": "2013-03-30T14:20:38.530Z", 
        "purchased": true
      }
    ]
###### Error codes: <!-- TODO -->

