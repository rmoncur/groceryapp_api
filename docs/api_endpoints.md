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
	* [Login](#login) - **POST** /users/login
	* [Read](#read) - **GET** /users/:user_id
	* [Update](#update) - **PUT** /users/:user_id
	* [Delete](#delete) - **DEL** /users/:user_id


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
	"email" : "caseymonc@gmail.com",
	"user_id": "afffe332234222",
	"token": "adba0d-eee4535-345252-abc4434",
	"username": "caseymonc",
  	"points": 0
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
	"email" : "caseymonc@gmail.com",
	"user_id": "afffe332234222",
	"token": "adba0d-eee4535-345252-abc4434",
	"username": "caseymonc",
  "points": 0
}
###### Error codes: <!-- TODO -->


#### Read

    GET /users/:user_id?token=adba0d-eee4535-345252-abc4434

###### Example Request:
###### Expected Result:
{
	"email" : "caseymonc@gmail.com",
	"user_id": "afffe332234222",
	"token": "adba0d-eee4535-345252-abc4434",
	"username": "caseymonc",
  "points": 0
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


## Tags

#### Create

    POST /tags

###### Example Request:
{
	"name": "milk",
	"user_id": "afffe332234222",
	"category" : "dairy",
	"related" : [
	{"name" : "cheese"}]},
	"compliment" : [
	{"name" : "cereal"},
	{"name" : "cookies"}]}
