jQuery.ajaxSetup({
//	error: function (xhr, textStatus, errorThrown) {
//		ok(false, textStatus + ": " + errorThrown + " | Response: " + xhr.responseText);
//	},
//	complete: function () {
//		start();
//	},
	beforeSend: function () {
		stop();
	}
});

$(document).ajaxComplete(function () {
	start();
});

function error(response) {
	ok(false, response.status + " | " + response.responseText);
}

function randomNumber(lower, upper) {
	return Math.floor((Math.random()*upper)+lower);
}

function randomString(minLength, maxLength) {
	var size = randomNumber(minLength, maxLength);
	var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz ";
	var randomstring = '';
	for (var i=0; i < size; i++) {
		var rnum = Math.floor(Math.random() * chars.length);
		randomstring += chars.substring(rnum, rnum+1);
	}
	
	return randomstring;
}

function randomNumberString(minLength, maxLength) {
	var size = randomNumber(minLength, maxLength);
	var chars = "0123456789";
	var randomstring = '';
	for (var i=0; i < size; i++) {
		var rnum = Math.floor(Math.random() * chars.length);
		randomstring += chars.substring(rnum, rnum+1);
	}
	
	return randomstring;
}
