			
test("Products", function () {
//	clearProductDatabase();
//	testGetProducts();
//	testCreateProducts();
	randomizedTests();
	testErrors();
});

function removeSomeAttributes(product) {
	var attributes  = [
		'name',
		'barcode',
		'description',
		'amount',
		'unit',
	]
	
	var newProduct = {}
	
	var numOfAttrsToKeep = randomNumber(1, 5);
	for(var i = 0; i < numOfAttrsToKeep; i++) {
		var attrIndexToAdd = randomNumber(0, 4 - i);
		var attr = attributes[attrIndexToAdd];
		attributes.splice(attrIndexToAdd, 1);
		
		if(attr == 'unit' || attr == 'amount') {
			if(newProduct['size'] == undefined) newProduct['size'] = {}
			newProduct['size'][attr] = product['size'][attr];
		}
		else {
			newProduct[attr] = product[attr];
		}
	}
	
	newProduct['product_id'] = product['product_id'];
	
	return newProduct;
}

function fillInMissingAttributes(partial, complete) {
	for(var attr in complete) {
		if(partial[attr] == null)
			partial[attr] = complete[attr];
	}
	
	return partial;
}


function randomizedTests() {
	for(var i = 0; i < 30; i++) {
		randomTest();
	}
}

function randomTest() {
	var expected = {
		name: randomString(0, 20),
		barcode: randomNumberString(10, 13),
		description: randomString(0, 100),
		size: {
			amount: randomNumber(0, 200),
			unit: randomString(0, 20)
		}
	}
	
	$.ajax({
		url: "/products",
		type: 'post',
		data: expected,
		complete: function (res) {
			if(res.status == 200) {
				var result = JSON.parse(res.responseText);
				
				//Add the product_id so that the deepEqual will work.
				expected['product_id'] = result.product_id;
				deepEqual(result, expected, "Create product");
				
				var productUpdate = removeSomeAttributes(expected);
				
				$.ajax({
					url: "/products/" + productUpdate.product_id,
					type: "put",
					data: productUpdate,
					complete: function (res) {
						if(res.status == 200) {
							var putResult = JSON.parse(res.responseText);
							
							var expectedUpdate = fillInMissingAttributes(productUpdate, expected);
							
							deepEqual(putResult, expectedUpdate, "Update product");
							
							$.ajax({
								url: "/products/" + expectedUpdate.barcode,
								type: "get",
								complete: function (res) {
									if(res.status == 200) {
										var getResult = JSON.parse(res.responseText);
										
										deepEqual(getResult, expectedUpdate, "Get product");
										
									}
									else error(res, "Get product failed");
								}
							});
						}
						else error(res, "Update product failed")
					}
				});
			}
			else error(res, "Create product failed");
		}
	});
}

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

function testErrors() {
	var product = {
		name: "error product"
	}

	$.ajax({
		url: "/products/321321321321",
		type: "put",
		data: product,
		complete: function (res) {
			if(res.status == 404) ok(true, "Product not found error successfully thrown");
			else error(res, "Updating not existing product test should have returned 404 error");
		}
	});
	
	$.ajax({
		url: "/products",
		type: "post",
		data: product,
		complete: function (res) {
			if(res.status == 409) ok(true, "Barcode required error successfully thrown");
			else ok(false, "A product without a barcode was allowed to be created");
		}
	});
	
	$.ajax({
		url: "/products",
		type: "post",
		data: {},
		complete: function (res) {
			if(res.status == 409) ok(true, "Barcode required error successfully thrown");
			else ok(false, "A product without a barcode was allowed to be created");
		}
	});
	
	var randomBarcode = randomNumberString(6, 8);
	
	$.ajax({
		url: "/products",
		type: "post",
		data: { barcode: randomBarcode, description: "First description" },
		complete: function (res) {
			if(res.status == 200) ok(true, "Created product");
			else error(res, "Error creating product");
			
			var existingProduct = { barcode: randomBarcode, description: "A product that already exists and shouldn't be added" }
			
			$.ajax({
				url: "/products",
				type: "post",
				data: existingProduct,
				complete: function (res) {
					if(res.status == 409) ok(true, "Reject creating of existing product");
					else error(res, "The creation of a product with a duplicate barcode did not return error");
				}
			});
		}
	});
}

