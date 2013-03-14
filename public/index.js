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

module.controller('TodoController', function ($scope, $navigate,$waitDialog,$http){
	$scope.user = {};

	$scope.lookup = [{"name":"woof"},{"name":"woof2"},{"name":"woof3"}]
	
	//Registration/login data
	$scope.regdata = {};
	$scope.logindata = {"email":"robmonc@gmail.com","password":"password"};
	
	//Session data
	$scope.location = {"lat":40.2387,"lon":-111.658};
	$scope.storesNearby = [];
	$scope.selectedStore = {};
	$scope.report = {"barcode":"051000013477","price":"1.52","img":"http://cdn1.iconfinder.com/data/icons/BRILLIANT/education_icons/png/400/teachers_day.png","name":"Apple"}
	
	
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
				console.log("Success",data,ajax,xhr);
				$scope.user = data;
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
	
	//Lookup an item
	$scope.readItem = function(){
		console.log("Sending",$scope.report);
		
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
				alert("Error Reading Item");	
			}
		});
			
	}
	
	//Reporting a new item
	$scope.createProduct = function(){
		console.log("Sending",$scope.report);
		
		//Getting the data to create the product
		var mydata = {
			"barcode": $scope.report.barcode,       //required
			"name": $scope.report.name,             //optional
			"size": "N/A",                          //optional
			"description": $scope.report.barcode    //optional
		};
		
		//Sending the request
		$.ajax({
			type:"POST",
			processData: true,
			data:{},
			url: '/products',
			success: function(data,ajax,xhr){
				console.log("Success Product",data,ajax,xhr);
				//$scope.report.description = data.description;
				$scope.$apply();
			},
			error: function(){
				alert("Error Creating Product");	
			}
		});
			
	}
	
	//Reporting a new item
	$scope.createPurchase = function(){
		console.log("Sending",$scope.report);
		
		var mydata = {
			"user_id": $scope.user.user_id,      //required
			"store_id": $scope.selectedStore.store_id,	//required
			"items": [{                         //optional
				"product_id": "3",              //required
				"price": 12.30                  //required
			}],
			"total": 13.07,                     //required
			//"purchaseDate": "05/30/2012"        //optional, defaults to now
		};
		
		$.ajax({
			type:"POST",
			processData: true,
			data:{},
			url: '/products/' + $scope.report.barcode,
			success: function(data,ajax,xhr){
				console.log("Success Product",data,ajax,xhr);
				$scope.report.description = data.description;
				//$scope.storesNearby = data;
				//$scope.selectedStore = $scope.storesNearby[0];
				$scope.$apply();
			},
			error: function(){
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
	beforeSend:function(){ $.mobile.loading( 'show' )   },
	complete:function(){ $.mobile.loading( 'hide' ) }
});