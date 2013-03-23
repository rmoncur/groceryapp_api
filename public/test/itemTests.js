test("Items", function () {

	//********** ERRORS ***********
	$.ajax({
		url: "/items",
		type: 'post',
		data: { },
		complete: function (res) {
			if(res.status == 409) {
				var result = JSON.parse(res.responseText);
				deepEqual(result["fields"], ['price', 'store_id', 'product_id', 'user_id'], "required fields");
			}
			else error(res)
		}
	});
	
	$.ajax({
		url: "/items",
		type: 'post',
		data: { store_id: "123123123123123123123123", product_id: "789789789789789789789789", user_id: "456465465456456546456465" },
		complete: function (res) {
			if(res.status == 409) {
				var result = JSON.parse(res.responseText);
				deepEqual(result["fields"], ['price'], "price required");
			}
			else error(res)
		}
	});
	
	$.ajax({
		url: "/items",
		type: 'post',
		data: { price: 12, product_id: "789789789789789789789789", user_id: "456465465456456546456465" },
		complete: function (res) {
			if(res.status == 409) {
				var result = JSON.parse(res.responseText);
				deepEqual(result["fields"], ['store_id'], "store_id required");
			}
			else error(res)
		}
	});
	
	$.ajax({
		url: "/items",
		type: 'post',
		data: { store_id: "123123123123123123123123", price: 12, user_id: "456465465456456546456465" },
		complete: function (res) {
			if(res.status == 409) {
				var result = JSON.parse(res.responseText);
				deepEqual(result["fields"], ['product_id'], "product_id required");
			}
			else error(res)
		}
	});
	
	$.ajax({
		url: "/items",
		type: 'post',
		data: { store_id: "123123123123123123123123", product_id: "789789789789789789789789", price: 12 },
		complete: function (res) {
			if(res.status == 409) {
				var result = JSON.parse(res.responseText);
				deepEqual(result["fields"], ['user_id'], "user_id required");
			}
			else error(res)
		}
	});
	
	$.ajax({
		url: "/items",
		type: 'post',
		data: { date: "junk", price: 12, store_id: "123123123123123123123123", product_id: "789789789789789789789789", user_id: "456465465456456546456465" },
		complete: function (res) {
			if(res.status == 409) {
				var result = JSON.parse(res.responseText);
				equal(result.message, "Invalid date", "Invalid date check");
			}
			else error(res)
		}
	});
	
	$.ajax({
		url: "/items/191919191919191919195555",
		type: 'get',
		complete: function (res) {
			if(res.status == 404) {
				var result = JSON.parse(res.responseText);
				equal(result.message, "Item not found", "Get fake item");
			}
			else error(res);
		}
	});
	
	$.ajax({
		url: "/items/191919191919191919195555",
		type: 'put',
		complete: function (res) {
			if(res.status == 404) {
				var result = JSON.parse(res.responseText);
				equal(result.message, "Item not found", "Update fake item");
			}
			else error(res);
		}
	});
	
	
	//********** CREATE ***********
	
	var newItem1 = { price: 12, store_id: "123123123123123123123123", product_id: "234234234234234234234234", user_id: "345345345345345345345345" }
	var newItem2 = { date: "03/17/2013", price: 23, store_id: "456456456456456456456456", product_id: "567567567567567567567567", user_id: "678678678678678678678678" }
	var newItem3 = { purchased: true, date: "03/10/2013", price: 34, store_id: "789789789789789789789789", product_id: "890890890890890890890890", user_id: "135135135135135135135135" }
	var update1 = { price: 90, store_id: "a12a12a12a12a12a12a12a12", product_id: "b12b12b12b12b12b12b12b12", date: new Date().toISOString(), purchased: true }
	var update2 = { price: 80, product_id: "c12c12c12c12c12c12c12c12" }
	var update3 = { item_id: "951951951951951951951951", user_id: "65c65c65c65c65c65c65c65c" }
	
	$.ajax({
		url: "/items",
		type: 'post',
		data: newItem1,
		complete: function (res) {
			if(res.status == 201) {
				var result = JSON.parse(res.responseText);
				newItem1['date'] = result.date;
				newItem1['item_id'] = result.item_id;
				newItem1['purchased'] = result.purchased;
				
				deepEqual(result, newItem1, "create item");
				
				testGetItem(newItem1.item_id, newItem1, function () { 
					testUpdateItem(newItem1, update1);
					badUpdateTest1();
				});
				
			}
			else error(res)
		}
	});
	
	$.ajax({
		url: "/items",
		type: 'post',
		data: newItem2,
		complete: function (res) {
			if(res.status == 201) {
				var result = JSON.parse(res.responseText);
				newItem2['date'] = new Date("03/17/2013").toISOString();	
				newItem2['item_id'] = result.item_id;
				newItem2['purchased'] = result.purchased;
				
				deepEqual(result, newItem2, "create item with date");
				
				testGetItem(newItem2.item_id, newItem2, function () {
					testUpdateItem(newItem2, update2);				
				});

			}
			else error(res)
		}
	});
	
	$.ajax({
		url: "/items",
		type: 'post',
		data: newItem3,
		complete: function (res) {
			if(res.status == 201) {
				var result = JSON.parse(res.responseText);
				newItem3['date'] = new Date("03/10/2013").toISOString();	
				newItem3['item_id'] = result.item_id;
				
				deepEqual(result, newItem3, "create item with date and purchased");
				
				testGetItem(newItem3.item_id, newItem3, function () {
					testUpdateItem(newItem3, update3);
				});
				
			}
			else error(res)
		}
	});
	
	
	function badUpdateTest1() {
		$.ajax({
			url: "/items/" + newItem1.item_id,
			type: 'put',
			data: { price: "" },
			complete: function (res) {
				if(res.status == 409) {
					var result = JSON.parse(res.responseText);
					equal(result.message, "Validation failed", "bad update");
				}
				else error(res);
			}
		});
	}
	
});



function testGetItem(itemId, expectedItem, cb) {
	$.ajax({
		url: "/items/" + itemId,
		type: "get",
		complete: function (res) {
			if(res.status == 200) {
				var result = JSON.parse(res.responseText);
				deepEqual(result, expectedItem, "Get newly created item");
				cb();
			}
			else error(res);
		}
	});
}

//********** UPDATE ***********
function testUpdateItem(original, updates) {	
	$.ajax({
		url: "/items/" + original.item_id,
		type: "put",
		data: updates,
		complete: function (res) {
			if(res.status == 200) {
				var result = JSON.parse(res.responseText);
				var expected = original;
			
				//things that should have been updated
				if(updates.price != undefined) expected.price = updates.price;
				if(updates.store_id != undefined) expected.store_id = updates.store_id;
				if(updates.product_id != undefined) expected.product_id = updates.product_id;
				if(updates.date != undefined) expected.date = updates.date;
				if(updates.purchased != undefined) expected.purchased = updates.purchased;
			
				deepEqual(result, expected, "update item");
			}
			else error(res)
		}
	});
}






