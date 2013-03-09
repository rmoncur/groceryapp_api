			
test("Products", function () {
	testGetProducts();
});


function testGetProducts() {

	var expected = {
		name: "", 
		barcode: "12345", 
		description: "2356 22 beans", 
		_id: "513b82836deb612f3f000006", 
		__v: 0
	};
	
	$.ajax({
		url: "/products/12345",
		type: 'GET',
		complete: function (res) {
			if(res.status == 200) {
				var result = JSON.parse(res.responseText);
				deepEqual(result, expected, "Get 12345");
			}
			else
				error(res);
		}
	});
	
	$.ajax({
		url: "/products",
		type: 'GET',
		complete: function (res) {
			if(res.status == 404) {
				ok(true, "Get all products doesn't exist");
			}
			else 
				error(res);
		}
	});
	
	$.ajax({
		url: "/products/0987654321",
		complete: function (res) {
			if(res.status == 200) {
				ok(true, "Product was found");
			}
			else
				error(res);
		}
	});
							
}
