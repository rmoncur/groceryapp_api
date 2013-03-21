# API Endpoints
###### Notes:
This Document is intended to be comprehensive. It is to
be used as an API development guide as well as a client implementation guide.
If there is a deficiency in either respect, make sure it is brought to our
attention so that the documentation can be amended BEFORE any work is done to
fix the deficiency.

## Navigation
* [Tags](#tags)
	* [Create](#create) - **POST** /users/:user_id/tags
	* [Get](#get) - **GET** /users/:user_id/tags/?tag_id=tag_id
	* [GetAll](#getall) - **GET** /users/:user_id/tags/
	* [Update](#update) - **PUT** /users/:user_id/tags/:tag_id
	* [Delete](#delete) - **DELETE** /users/:user_id/tags/:tag_id
	* [Search](#search) - **GET** /users/:user_id/tags/?search=search_string

## Tags

#### Create

    POST /users/:user_id/tags

###### Example Request:
{
	"name": "milk",
	"user_id": "afffe332234222",
	"category" : "dairy",
	"related" : [{"name" : "cheese"}],
	"compliment" : [{"name" : "cereal"},{"name" : "cookies"}]
}
###### Expected Result:
{
	
}