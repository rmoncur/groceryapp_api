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
	$scope.logindata = {};
	
	//Session data
	$scope.location = {"lat":41.2,"lon":-111.2};
	$scope.storesNearby = {};
	
	
	$scope.start = function(){
		if( typeof $scope.user.username == "undefined" ){
			console.log("yikes");
			$.mobile.changePage($("#login"));
		}
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
	$scope.getStoresNearby = function($http){
		
		$.ajax({
			type:"POST",			
			data:JSON.stringify($scope.location),
			url: '/stores/nearby',
			success: function(data,ajax,xhr){
				console.log("Success Location",data,ajax,xhr);
				$scope.storesNearby = data;
				//$.mobile.changePage($("#dashboard"),"slide");
			}						
		});		
			
	}
	
});

//Setting some defaults
$.ajaxSetup({
	processData: false,
	contentType: 'application/json',
	error: function(){ console.log("Error"); }
});