// Shaven 0.4.0 by Adrian Sieber (adriansieber.com)


// array: Array containing the DOM fragment in JsonML
// returnObject: Contains elements identified by their id

shaven = function dom (array, namespace, returnObject) {

	'use strict'

	var doc = document,
	    unescaped,
	    callback,
	    attribute,
	    i

	// Set on first iteration
	returnObject = returnObject || {}

	// Set default namespace to XHTML namespace
	namespace = namespace || 'http://www.w3.org/1999/xhtml'

	// Create DOM element from syntax sugar string
	function createElement (sugarString) {

		var tags = sugarString.match(/^\w+/),
		    tag = tags ? tags[0] : 'div',
		    element = doc.createElementNS(namespace, tag),
		    id = sugarString.match(/#([\w-]+)/),
		    ref = sugarString.match(/\$([\w-]+)/),
		    classNames = sugarString.match(/\.[\w-]+/g)

		// Assign id if is set
		if (id) {

			element.id = id[1]

			// Add element to the return object
			returnObject[id[1]] = element
		}

		// Create reference to the element and add it to the return object
		if (ref)
			returnObject[ref[1]] = element

		// Assign class if is set
		if (classNames)
			element.setAttribute('class', classNames.join(' ').replace(/\./g, ''))

		// Don't escape HTML content
		if (sugarString.match(/&$/g))
			unescaped = true

		// Return DOM element
		return element
	}

	// TODO: Create customised renderer
	// If is object
	// if (array === Object(array)) {

	// } else {

	// If is string create DOM element else is already a DOM element
	if (typeof array[0] === 'string')
		array[0] = createElement(array[0])

	// For each in the element array (except the first)
	for (i = 1; i < array.length; i++) {

		// Don't render element if value is false or null
		if (array[i] === false || array[i] === null) {
			array[0] = false
			break
		}

		// Render element with empty body if value is undefined
		else if (array[i] === undefined) {
			continue
		}

		// If is string has to be content so set it
		else if (typeof array[i] === 'string' || typeof array[i] === 'number')
			if (unescaped)
				array[0].innerHTML = array[i]

			else
				array[0].appendChild(doc.createTextNode(array[i]))

		// If is array has to be child element
		else if (Array.isArray(array[i])) {

			// Use shaven recursively for all child elements
			dom(array[i], namespace, returnObject)

			// Append the element to its parent element
			if (array[i][0])
				array[0].appendChild(array[i][0])
		}

		else if (typeof array[i] === 'function')
			callback = array[i]

		// If it is an element append it
		else if (array[i] instanceof Element)
			array[0].appendChild(array[i])

		// Else must be an object with attributes
		else if (typeof array[i] === 'object')
		// For each attribute
			for (attribute in array[i])
				if (array[i].hasOwnProperty(attribute))
					array[0].setAttribute(attribute, array[i][attribute])

				else
					throw new TypeError('"' + array[i] + '" is not allowed as a value.')
	}
	// }

	// Return root element on index 0
	returnObject[0] = array[0]

	if (callback) callback(array[0])

	// returns object containing all elements with an id and the root element
	return returnObject
}
