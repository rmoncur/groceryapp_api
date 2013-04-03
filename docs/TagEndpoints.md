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
	* [GetByCategory](#getCategory) - **GET** /
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

#### Get

	GET /users/:user_id/tags/?tag_id=tag_id

###### Example Request:
{
}
###### Expected Result:
{	
}

#### GetByCategory

	GET /users/511a9a244bcab18c13000002/tags/?category=dairy&token=a0381679-8dc5-4aaa-bb34-87f410cd3420-3e9-66-d06f67668d

###### Example Request:
{
}
###### Expected Result:
[
    {
        "userId": "511a9a244bcab18c13000002",
        "name": "milk",
        "category": "dairy",
        "_id": "513fa31c4832968016000006",
        "__v": 0,
        "complimentTags": [
            "[object Object]"
        ],
        "relatedTags": [
            "[object Object]",
            "[object Object]"
        ]
    },
    {
        "userId": "511a9a244bcab18c13000002",
        "name": "milk",
        "category": "dairy",
        "_id": "513fa3294832968016000007",
        "__v": 0,
        "complimentTags": [
            "[object Object]"
        ],
        "relatedTags": [
            "[object Object]",
            "[object Object]"
        ]
    }
]

#### Update

	PUT /users/:user_id/tags/:tag_id

###### Example Request:
{
}
###### Expected Result:
{	
}

#### Delete

	DELETE /users/:user_id/tags/:tag_id

###### Example Request:
{
}
###### Expected Result:
{	
}

#### Search

	GET /users/:user_id/tags/?search=search_string

###### Example Request:
{
}
###### Expected Result:
{
    "userId": "511a9a244bcab18c13000002",
    "name": "milk",
    "category": "dairy",
    "_id": "513fa31c4832968016000006",
    "__v": 0,
    "complimentTags": [
        "[tag_id]"
    ],
    "relatedTags": [
        "[tag_id]",
        "[tag_id]"
    ]
}

