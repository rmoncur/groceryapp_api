			
test("Products", function () {
	testGetProducts();
	testCreateProducts();
});


function testGetProducts() {

	var expected = {
		name: "", 
		barcode: "12345", 
		description: "2356 22 beans", 
		product_id: "513b82836deb612f3f000006",
		size: {}
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

function testCreateProducts() {
	var newProduct = {
		name: "Trevor's new product",
		description: "Description of the new product",
		barcode: "0999999999999",
		user_id: "1",
		size: { 
			amount: 16,
			unit: "oz"
		}			
	}
	
	$.ajax({
		url: "/products",
		type: 'post',
		data: newProduct,
		complete: function (res) {
			if(res.status == 200) {
				var result = JSON.parse(res.responseText);
				
				//Add the product_id so that the deepEqual will work.
				newProduct['product_id'] = result.product_id;
				deepEqual(result, newProduct, "Check if product was created");
			}
			else error(res);
		}
	});
}

