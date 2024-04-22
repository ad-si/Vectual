!function (document, window) {

	// Random Colors
	var sheet = document.styleSheets[0],
	    numRules = sheet.cssRules.length, obj, generatorObj


	function randColor () {

		function randNum () {
			return Math.floor(100 + Math.random() * 155)
		}

		return 'rgb(' + randNum() + ',' + randNum() + ',' + randNum() + ')'
	}


	sheet.insertRule('#logo a:hover {color: ' +
	                 randColor() + '}', numRules)
	sheet.insertRule('a[href="#about"]:hover {background-color: ' +
	                 randColor() + '}', numRules)
	sheet.insertRule('a[href="#demos"]:hover {background-color: ' +
	                 randColor() + '}', numRules)
	sheet.insertRule('a[href="#generator"]:hover {background-color: ' +
	                 randColor() + '}', numRules)
	sheet.insertRule('a[href="#documentation"]:hover {background-color: ' +
	                 randColor() + '}', numRules)


	// Vectual Banner
	obj = {
		"title": "Fruit Consumption",
		"id": "banner",
		"height": 180,
		"width": 240,
		"animations": true,
		"inline": false,
		"data": {
			"Apple": 50,
			"Plum": 27,
			"Peach": 11,
			"Lime": 2,
			"Cherry": 13,
			"Pineapple": 69,
			"Melon": 26,
			"Grapefruit": 35,
			"Strawberry": 56,
			"Orange": 34,
			"Kiwi": 65
		}
	}

	vectual(obj).pieChart()

	vectual(obj).barChart()

	obj.data = {
		"January": 50,
		"February": 27,
		"March": 11,
		"April": 2,
		"May": 13,
		"June": 69,
		"July": 26,
		"August": 35,
		"September": 56,
		"October": 34,
		"November": 65,
		"December": 57
	}

	vectual(obj).lineChart()


	//Generator
	$('[href="#generator"]').click(function (event) {
		$('#generator').slideToggle()
		event.preventDefault()
	})

	generatorObj = {
		"title": "Fruit Consumption",
		"id": "showcase",
		"height": 200,
		"width": 300,
		"animations": true,
		"inline": false,
		"data": {
			"Apple": 50,
			"Plum": 27,
			"Peach": 11,
			"Lime": 2,
			"Cherry": 13,
			"Pineapple": 69,
			"Melon": 26,
			"Grapefruit": 35,
			"Strawberry": 56,
			"Orange": 34,
			"Kiwi": 65
		},
		"callback": function () {
			alert('test')
		}
	}

	vectual(generatorObj).pieChart()

}(document, window)
