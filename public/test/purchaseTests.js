test("Purchases", function () {
	randomizedTests();
});

var purchaseBase = {
	purchase_id: "id",
	user_id: "id",
	store_id: "id",
	items: {
		product_id: "id",
		price: "number"
	},
	date: "date"
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
