// JavaScript Document
/*$(document).ready(function(e) {
	
	module.start();
	
	var scope = angular.element("#login").scope();
	if( typeof scope.user.username == "undefined" ){
		console.log("yikes");
		$.mobile.changePage($("#login"));
	}
});*/


module = angular.module("grocery", []);

module.controller('TodoController', function ($scope,$navigate,$waitDialog,$http){
	
	$scope.host = "";
	
	//Dashboard Data
	$scope.user = {		
		//Have these
		email: "robmonc@gmail.com",
		token: "86c966fa-ac5d-4d93-b0a6-436a41e5d7f6-528-c5-fb2d0ad649",
		user_id: "513f662d20d0a0b03a000005",
		username: "robmoncur",		 
		
		//Still need these guys
		points: 12042,
		img:'http://www.gravatar.com/avatar/' + md5("robmonc@gmail.com"),		
		location:"Orem,Utah, United States",
		level:{
			level:12,
			progress:21.0,			
			leveluppoints:25.0
		},
		itemsreported:2132,
		storesvisited:12
	};	
	
	$scope.reported = [
		{"name":"Reported Item 1","price":1.42},
		{"name":"Reported Item 2","price":1.69},	
	]
	$scope.stores = [
		{"name":"Maceys"},
		{"name":"Smiths"},		
	]
		
	//Leaderboard Data
	$scope.leaderboard = {
		"monthly":{
			"users":[{"name":"John Smith","points":142},{"name":"Jefferson","points":203}],
			"me":{
				"points":204,
				"rank":4
			}
		},
		"overall":{
			"users":[{"name":"John Smith","points":142},{"name":"Jefferson","points":203}],
			"me":{
				"points":1422,
				"rank":23
			}
		}
	}
	
	//Registration/login data
	$scope.regdata = {};
	$scope.logindata = {"email":"robmonc@gmail.com","password":"password"};
	
	//Session data
	$scope.location = {"lat":40.2387,"lon":-111.658};
	$scope.storesNearby = [];
	$scope.selectedStore = {};
	$scope.report = {
		barcode:"051000013477",
		price:"1.52",
		img:"http://cdn1.iconfinder.com/data/icons/BRILLIANT/education_icons/png/400/teachers_day.png"
		,name:"Granny Smith Apple"
		,units_abrev:"gal."
		,units:"gallons"
		,size:4.4
	}
	
	//Product Data
	$scope.lookup = [{"name":"Item #1"},{"name":"Item #2"},{"name":"Item #3"},{"name":"Item #4"}];
	$scope.product = {
		name:"Campbell's Cheese Soup",
		description:"This is the most delicious soup ever",
		size:"14",
		units:"ounces",
		units_abrev:"oz.",
		numReports:32,
	};
	
	// ----- Methods ----- //
	
	$scope.start = function(){
		navigator.geolocation.getCurrentPosition($scope.myloc);
		/*if( typeof $scope.user.username == "undefined" ){
			console.log("yikes");
			$.mobile.changePage($("#login"));
		}*/
	}
	
	//Logging in
	$scope.login = function($http){				
		
		$.ajax({
			type:"POST",
			processData: false,
			contentType: 'application/json',
			data:JSON.stringify($scope.logindata),
			url: '/users/login',
			success: function(data,ajax,xhr){
				console.log("Success Login",data,ajax,xhr);
				$scope.user = data;
				$scope.user.purchases = [{"name":"French fries"},{"name":"French Dip"}];
				
				$scope.user.img = 'http://www.gravatar.com/avatar/' + md5($scope.logindata.email);
				
				$.mobile.changePage($("#dashboard"),"slide");
				//$.mobile.navigate("#dashboard");
			},
			error: function(){
				console.log("Error");	
			}						
		});
		
	}
	
	//Register a new user
	$scope.register = function($http){
		
		$.ajax({
			type:"POST",
			data:JSON.stringify($scope.regdata),
			url: '/users',
			success: function(data,ajax,xhr){
				console.log("Success",data,ajax,xhr);
				$scope.user = data;
				$.mobile.changePage($("#dashboard"),"slide");
			}									
		});
		
	}
	
	//Logout
	$scope.logout = function($http){
		$.scope.user = {};
		$.mobile.changePage($("#login"),"slide");
	}
	
	//Getting nearby stores
	$scope.getStoresNearby = function(){
		
		$.ajax({
			type:"GET",
			processData: true,
			data:$scope.location,
			url: '/stores/nearby',
			success: function(data,ajax,xhr){
				console.log("Success Location",data,ajax,xhr);
				$scope.storesNearby = data;
				$scope.selectedStore = $scope.storesNearby[0];
				$scope.$apply();
			}						
		});		
			
	}
	
	//Getting my location
	$scope.myloc = function(mylocation){
		console.log("My Location",mylocation);	
		$scope.location = mylocation;
		$scope.location.lat = mylocation.coords.latitude;
		$scope.location.lat = mylocation.coords.longitude;	
		
		$scope.getStoresNearby();	
	}
	
	//Selecting a store
	$scope.selectStore = function(store){ $scope.selectedStore = store; $scope.$apply(); }
	
	//Getting user purchases
	$scope.getUserPurchases = function(){
		
		$.ajax({
			type:"GET",
			processData: true,
			data:{},
			url: '/users/' + $scope.user.user_id + "/purchases",
			success: function(data,ajax,xhr){
				console.log("Success User Purchases",data,ajax,xhr);
				$scope.user.purchases = data;
				$scope.$apply();
			}						
		});
	}
	
	// ---- UNDER ---- CONSTRUCTION ---- //
	
	//Lookup an item
	$scope.readItem = function(){
		console.log("Sending",$scope.report);
		
		var barcode = $scope.report.barcode;
		
		//alert( typeof barcode );
		
		if( $scope.report.barcode.length != 8 && $scope.report.barcode.length != 12 ){ 	
			//alert("UPC Length must be 8 or 12 = " + $scope.report.barcode.length);
			//return;
		}
		
		$.ajax({
			type:"GET",
			processData: true,
			data:{},
			url: '/products/' + $scope.report.barcode,
			success: function(data,ajax,xhr){
				console.log("Success Product",data,ajax,xhr);
				$scope.report.description = data.description;
				$scope.report.name = data.name;
								
				$scope.$apply();
			},
			error: function(){
				//alert("Error Reading Item");	
			}
		});
			
	}
	
	//Reporting an item
	$scope.reportItem = function(){
		$scope.createProduct();
	}
	
	//Reporting a new item
	$scope.createProduct = function(){
				
		//Getting the data to create the product
		var mydata = {			
			barcode: $scope.report.barcode,       //required
			name: $scope.report.name,             //optional
			size: {
				amount: $scope.report.size,       //optional
				units: $scope.report.units,       //optional
			},
			description: $scope.report.description//optional
		};
		
		console.log("Creating a Product",mydata);
		
		//Sending the request
		$.ajax({
			type:"POST",
			data:JSON.stringify(mydata),
			url: '/products',
			success: function(data,ajax,xhr){
				console.log("Success Creating Product",data,ajax,xhr);
				$scope.report.product_id = data.product_id;
				console.log("Report Data",$scope.report);
				//$scope.report.description = data.description;
				$scope.$apply();
				
				$scope.createPurchase();
			},
			error: function(){
				//alert("Error Creating Product");	
			}
		});
			
	}
	
	//Reporting a new item
	$scope.createPurchase = function(){		
		
		var mydata = {
			"user_id": $scope.user.user_id,      		//required
			"store_id": $scope.selectedStore.store_id,	//required
			"items": [{                         		//optional
				"product_id": $scope.report.product_id, //required
				"price": $scope.report.price            //required
			}],
			"total": $scope.report.price,                     //required
			//"purchaseDate": "05/30/2012"        //optional, defaults to now
		};
		
		console.log("Creating a Purchase",mydata);
		
		$.ajax({
			type:"POST",
			data:JSON.stringify(mydata),
			url: '/purchases/',
			success: function(data,ajax,xhr){
				console.log("Success Creating Purchase",data,ajax,xhr);
				$scope.report.description = data.description;
				//$scope.storesNearby = data;
				//$scope.selectedStore = $scope.storesNearby[0];
				$scope.$apply();
			},
			error: function(){
				console.log('Error creating a purchase');
				alert("Error");	
			}
		});
			
	}
	
});

function myloc(mylocation){
	
}

//Setting some defaults
$.ajaxSetup({
	processData: false,
	contentType: 'application/json',
	error: function(){ console.log("Error"); },
	//beforeSend:function(){ $.mobile.loading( 'show' )   },
	//complete:function(){ $.mobile.loading( 'hide' ) }
});