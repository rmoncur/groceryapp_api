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
