// @preserve vectual by Adrian Sieber

!function (window, document, undefined) {

	var svg,
	    svgNS = "http://www.w3.org/2000/svg",
	    dom = shaven,
	    config = {
		    id: "demo",
		    title: "vectual.js",
		    inline: false,
		    animations: true,
		    height: 300,
		    width: 500,
		    colors: [
			    'yellow',
			    'green',
			    'blue',
			    'brown',
			    'grey',
			    'yellow',
			    'green',
			    'blue',
			    'brown',
			    'yellow',
			    'green',
			    'blue',
			    'brown'
		    ]
	    }

	function toRad (degrees) {
		return degrees * (Math.PI / 180)
	}

	function Pie () {
		var circle,
		    text,
		    radius = Math.min(config.height, config.width * 0.2),
		    lastx = -radius,
		    lasty = 0,
		    angle_all = 0,
		    pie = dom(
			    ['g', {
				    'transform': 'translate(' + (0.5 * config.width) + ', ' + (0.5 * config.height) + ')'
			    }], svgNS
		    )[0]


		function init () {
			dom([svg, [pie]])
		}

		function build () {

			function drawSector (element, i) {

				var position,
				    angle_all_last = angle_all,
				    angle_this = ((config.sorted.values[i] / config.totalValue) * 360),
				    angle_add = angle_this / 2,
				    angle_all_rad,
				    trans_deg = angle_all_last + angle_add,
				    angle_translate = toRad(trans_deg),
				    tx = -(Math.cos(angle_translate)) * radius,
				    ty = (Math.sin(angle_translate)) * radius,
				    path,
				    text,
				    animate,
				    title,
				    nextx,
				    nexty,
				    size = (((config.sorted.values[i] /
				              config.totalValue) * 360) > 180) ? '0 1,0' : '0 0,0',
				    sector = dom(
					    ['g', {'class': "vectual_pie_sector"}], svgNS
				    )[0]


				function init () {

					//Angle
					angle_all = angle_this + angle_all
					angle_all_rad = toRad(angle_all)

					nextx = -(Math.cos(angle_all_rad) * radius)
					nexty = (Math.sin(angle_all_rad) * radius)

					position =
					(trans_deg <= 75) ? 'end' :
					(trans_deg <= 105) ? 'middle' :
					(trans_deg <= 255) ? 'start' :
					(trans_deg <= 285) ? 'middle' : 'end'
				}

				function build () {

					path = dom(
						['path', {
							'class': 'vectual_pie_sector_path',
							'style': 'stroke-width:' + (radius * 0.015) +
							         ';fill:' + config.colors[i],
							'd': 'M 0,0 L ' + lastx + ',' + lasty + ' A ' +
							     radius + ',' + radius + ' ' + size + ' ' +
							     nextx + ',' + nexty + ' z'}
						], svgNS
					)[0]

					text = dom(
						['text', {
							'class': 'vectual_pie_text',
							'x': (tx * 1.2),
							'y': (ty * 1.2),
							'text-anchor': position,
							'style': 'font-size:' +
							         (angle_this * radius * 0.002 + 8) + 'px',
							'fill': config.colors[i],
							'transform': 'translate(0, 5)'
						}], svgNS
					)[0]

					title = dom(
						['title',
								config.sorted.keys[i] + ' | ' +
								config.sorted.values[i] + ' | ' +
								(Math.round(config.sorted.values[i] /
								            config.totalValue * 100) ) + '%'
						], svgNS
					)[0]

				}

				function setAnimations () {

					dom(
						[sector,
							['animateTransform', {
								attributeName: 'transform',
								begin: 'mouseover',
								type: 'translate',
								to: (tx * 0.2) + ', ' + (ty * 0.2),
								dur: '300ms',
								additive: 'replace',
								fill: 'freeze'
							}],
							['animateTransform', {
								attributeName: 'transform',
								begin: 'mouseout',
								type: 'translate',
								to: '0,0',
								dur: '600ms',
								additive: 'replace',
								fill: 'freeze'
							}]
						], svgNS
					)

					dom(
						[path,
							['animate', {
								'attributeName': 'opacity',
								'from': '0',
								'to': '1',
								'dur': '0.6s',
								'fill': 'freeze'
							}],
							['animateTransform', {
								'attributeName': 'transform',
								'type': 'rotate',
								'dur': '1s',
								'calcMode': 'spline',
								'keySplines': '0 0 0 1',
								'values': angle_all_last + ',0,0; 0,0,0',
								'additive': 'replace',
								'fill': 'freeze'
							}]
						], svgNS
					)


					dom(
						[text,
							['animate', {
								'attributeName': 'opacity',
								'begin': '0s',
								'values': '0;0;1',
								'dur': '1s',
								'fill': 'freeze'
							}]
						], svgNS
					)

				}

				function inject () {
					dom(
						[pie,
							[sector,
								[path],
								[text],
								[title]
							]
						], svgNS
					)
				}

				init()
				build()
				if (config.animations)
					setAnimations()
				inject()

				lastx = nextx
				lasty = nexty
			}

			//Draw circle if only one value
			if (config.totalValue == config.max.value)
				dom(
					[pie,
						['circle', {
							'class': 'vectual_pie_sector',
							'cx': '0',
							'cy': '0',
							'r': radius,
							'fill': config.colors[1]
						}],
						['text', config.max.key, {
							'class': 'vectual_pie_text_single, vectual_pie_text',
							'x': '0',
							'y': '0',
							'style': 'font-size:' + (radius * 0.3) + 'px',
							'text-anchor': 'middle',
							'stroke-width': (radius * 0.006)
						}]
					], svgNS
				)
			else
				config.data.forEach(drawSector)

		}

		init()
		build()
	}

	function Bar () {

		var yDensity = 0.1,
		    yRange = (config.max.value - config.min.value),
		    g,
		    line,
		    text,
		    graphHeight = config.height * 0.8,
		    graphWidth = config.width * 0.95,
		    coSysHeight = config.height * 0.6,
		    coSysWidth = config.width * 0.85,
		    barchart = dom(
			    ['g', {
				    transform: 'translate(' +
				               (graphWidth * 0.1) + ', ' + graphHeight + ')'
			    }], svgNS
		    )[0],
		    coordinateSystem = dom(['g'], svgNS)[0],
		    bars = dom(['g'], svgNS)[0]


		function buildCoordinateSystem () {

			function ordinates () {

				var cssClass,
				    i

				for (i = 0; i < config.size; i++) {

					cssClass = (i == 0) ?
					           'vectual_coordinate_axis_y' :
					           'vectual_coordinate_lines_y'

					dom(
						[coordinateSystem,
							['line', {
								class: cssClass,
								x1: (coSysWidth / config.size) * i,
								y1: '5',
								x2: (coSysWidth / config.size) * i,
								y2: -coSysHeight
							}],
							['text', config.keys[i], {
								class: 'vectual_coordinate_labels_x',
								transform: 'rotate(40 ' +
								           ((coSysWidth / config.size) * i) +
								           ', 10)',
								x: ((coSysWidth / config.size) * i),
								y: 10
							}]
						], svgNS
					)
				}
			}

			function abscissas () {

				var styleClass,
				    line,
				    text,
				    i

				for (i = 0; i <= (yRange * yDensity); i++) {

					styleClass = (i == 0) ?
					             'vectual_coordinate_axis_x' :
					             'vectual_coordinate_lines_x'

					dom(
						[coordinateSystem,
							['line', {
								class: styleClass,
								x1: -5,
								y1: -(coSysHeight / yRange) * (i / yDensity),
								x2: coSysWidth,
								y2: -(coSysHeight / yRange) * (i / yDensity)
							}],
							['text', String(i / yDensity + config.min.value), {
								class: 'vectual_coordinate_labels_y',
								x: -coSysWidth * 0.05,
								y: -(coSysHeight / yRange) * (i / yDensity)
							}]
						], svgNS
					)
				}
			}

			abscissas()
			ordinates()
		}

		function buildBars () {

			function drawBar (element, i) {

				var height = config.animations ?
				             0 :
				             (config.values[i] - config.min.value) *
				             (coSysHeight / yRange),
				    bar = dom(
					    ['rect', {
						    class: 'vectual_bar_bar',
						    x: (i * (coSysWidth / config.size)),
						    y: -(config.values[i] - config.min.value) * (coSysHeight / yRange),
						    height: height,
						    width: (0.7 * (coSysWidth / config.size))
					    },
						    ['title', config.keys[i] + ':  ' + config.values[i]]
					    ], svgNS
				    )[0]

				function setAnimations () {
					dom(
						[bar,
							['animate', {
								attributeName: 'height',
								to: (config.values[i] - config.min.value) * (coSysHeight / yRange),
								begin: '0s',
								dur: '1s',
								fill: 'freeze'
							}],
							['animate', {
								attributeName: 'y',
								from: 0,
								to: -(config.values[i] - config.min.value) * (coSysHeight / yRange),
								begin: '0s',
								dur: '1s',
								fill: 'freeze'
							}],
							['animate', {
								attributeName: 'fill',
								to: 'rgb(100,210,255)',
								begin: 'mouseover',
								dur: '100ms',
								fill: 'freeze',
								additive: 'replace'
							}],
							['animate', {
								attributeName: 'fill',
								to: 'rgb(0,150,250)',
								begin: 'mouseout',
								dur: '200ms',
								fill: 'freeze',
								additive: 'replace'
							}]
						], svgNS
					)
				}

				function inject () {
					dom([bars, [bar]])
				}


				if (config.animations)
					setAnimations()
				inject()
			}

			config.data.forEach(drawBar)
		}

		function setAnimations () {
			dom(
				[bars,
					['animate', {
						attributeName: 'opacity',
						from: 0,
						to: 0.8,
						begin: '0s',
						dur: '1s',
						fill: 'freeze',
						additive: 'replace'
					}]
				], svgNS
			)
		}

		function inject () {
			dom(
				[svg,
					[barchart,
						[coordinateSystem],
						[bars]
					]
				]
			)
		}

		buildCoordinateSystem()
		buildBars()
		if (config.animations)
			setAnimations()
		inject()
	}

	function Line () {

		var yDensity = 0.1,
		    yRange = (config.max.value - config.min.value),
		    g,
		    text,
		    graphWidth = config.width * 0.95,
		    graphHeight = config.height * 0.8,
		    coSysWidth = config.width * 0.85,
		    coSysHeight = config.height * 0.6,
		    graph = dom(
			    ['g', {
				    'transform': 'translate(' + (graphWidth * 0.1) + ', ' + (graphHeight) + ')'
			    }], svgNS
		    )[0]

		function init () {
			dom([svg, [graph]])
		}

		function build () {

			function drawCoordinateSystem () {

				function horizontalLoop () {

					var cssClass, line

					for (var i = 0; i < config.size; i++) {

						cssClass = (i == 0) ? 'vectual_coordinate_axis_y' : 'vectual_coordinate_lines_y'

						dom(
							[graph,
								['line', {
									class: cssClass,
									x1: (coSysWidth / config.size) * i,
									y1: 5,
									x2: (coSysWidth / config.size) * i,
									y2: -coSysHeight
								}],
								['text', config.keys[i], {
									class: 'vectual_coordinate_labels_x',
									transform: 'rotate(40 ' + ((coSysWidth / config.size) * i) + ', 10)',
									x: ((coSysWidth / config.size) * i),
									y: 10
								}]
							], svgNS)

					}
				}

				function verticalLoop () {

					var styleClass,
					    line,
					    text

					for (var i = 0; i <= (yRange * yDensity); i++) {

						styleClass = (i == 0) ? 'vectual_coordinate_axis_x' : 'vectual_coordinate_lines_x'

						dom(
							[graph,
								['line', {
									'class': styleClass,
									'x1': -5,
									'y1': -(coSysHeight / yRange) * (i / yDensity),
									'x2': coSysWidth,
									'y2': -(coSysHeight / yRange) * (i / yDensity)
								}],
								['text', i / yDensity + config.min.value, {
									'class': 'vectual_coordinate_labels_y',
									'x': -coSysWidth * 0.05,
									'y': -(coSysHeight / yRange) * (i / yDensity)
								}]
							]
							, svgNS)

					}
				}

				horizontalLoop()
				verticalLoop()
			}

			function buildLine () {

				var points = '',
				    pointsTo = '',
				    line,
				    i,
				    j

				for (i = 0; i < config.size; i++) {
					points += (i * (coSysWidth / config.size)) + ',0 '
				}

				for (j = 0; j < config.size; j++) {
					pointsTo += (j * (coSysWidth / config.size)) + ',' +
					            ((-config.values[j] + config.min.value) *
					             (coSysHeight / yRange)) + ' '
				}

				line = graph
					.appendChild(document.createElementNS(svgNS, 'polyline'))
				line.setAttribute('class', 'vectual_line_line')
				line.setAttribute('points', pointsTo)


				if (config.animations) {

					dom(
						[line,
							['animate', {
								'attributeName': 'points',
								'from': points,
								'to': pointsTo,
								'begin': '0s',
								'dur': '1s',
								'fill': 'freeze'}
							],
							['animate', {
								'attributeName': 'opacity',
								'begin': '0s',
								'from': '0',
								'to': '1',
								'dur': '1s',
								'additive': 'replace',
								'fill': 'freeze'}
							]
						]
						, svgNS)

				}
			}

			function setDots () {

				var circle,
				    i

				for (i = 0; i < config.size; i++) {

					circle = dom(
						['circle', {
							'class': 'vectual_line_dot',
							'r': '4',
							'cx': i * (coSysWidth / config.size),
							'cy': (-config.values[i] + config.min.value) *
							      (coSysHeight / yRange)}

							, ['title', config.keys[i] + ':  ' + config.values[i]]
						]
						, svgNS)[0]


					graph.appendChild(circle)


					if (config.animations) {

						dom(
							[circle,
								['animate', {
									'attributeName': 'opacity',
									'begin': '0s',
									'values': '0;0;1',
									'keyTimes': '0;0.8;1',
									'dur': '1.5s',
									'additive': 'replace',
									'fill': 'freeze'
								}],
								['animate', {
									'attributeName': 'r',
									'to': '8',
									'dur': '0.1s',
									'begin': 'mouseover',
									'additive': 'replace',
									'fill': 'freeze'
								}],
								['animate', {
									'attributeName': 'r',
									'to': '4',
									'dur': '0.2s',
									'begin': 'mouseout',
									'additive': 'replace',
									'fill': 'freeze'}
								]
							]
							, svgNS)

					}
				}

			}

			drawCoordinateSystem()
			buildLine()
			setDots()
		}

		init()
		build()
	}

	function Tagcloud () {

		var minFontsize = 10, //minimum font-size
		    until = 300, //size of spiral
		    factor = 10, //resolution improvement
		    density = 0.2, //density of spiral
		    xySkew = 0.6, //elliptical shape of spiral (0 < xySkew < 1)
		    cloud = dom(
			    ['g', {
				    transform: 'translate(' +
				               (0.5 * config.width) + ', ' +
				               (0.5 * config.height) + ')',
				    class: 'vectualTagcloud'
			    }], svgNS
		    )[0]


		function init () {

			config.data.forEach(function (element) {

				//font-size
				element.fontSize = minFontsize +
				                   ((config.height * 0.1) *
				                    (element.value - config.min.value)) /
				                   (config.max.value - config.min.value)

				//bounding-box
				element.height = element.fontSize * 0.8
				element.width = element.key.length * element.fontSize * 0.5
			})

			dom([svg, [cloud]])
		}


		function build () {

			var pointsNumber = until * factor * density,
			    points = [],
			    i,
			    b,
			    x,
			    y


			function calculatePoints () {

				for (i = 0; i < pointsNumber; i++) {
					b = i * (1 / factor)

					x = -(1 / density) * xySkew * b * Math.cos(b)
					y = -(1 / density) * (1 - xySkew) * b * Math.sin(b)

					points.push({x: x, y: y})
				}
			}

			function drawSpiral () {

				var string = ''

				points.forEach(function (point) {
					string += point.x + ',' + point.y + ' '
				})

				dom(
					[cloud,
						['polyline', {
							points: string,
							style: 'fill: none; stroke:red; stroke-width:1'
						}]
					]
					, svgNS
				)
			}

			function drawWords () {

				function drawWord (element, index) {

					function calculatePosition () {

						//returns true if point was found and saves it in element
						function testPoint (point, pointIndex) {

							function notOverlapping (formerElement, formerIndex) {

								//if element is already set
								if (formerElement.x !== undefined) {

									return point.x > formerElement.x +
									                 formerElement.width //right
										       || point.x < formerElement.x -
										                    element.width //left
										       || point.y < formerElement.y -
										                    formerElement.height //above
										|| point.y > formerElement.y +
										             element.height //beyond

								}
								else
									return true
							}

							//test if every element is not overlapping
							if (config.data.every(notOverlapping) == true) {
								element.x = point.x
								element.y = point.y
								return true
							}
							else {
								return false
							}
						}

						if (points.some(testPoint) == false)
							throw new Error('Element could not be positioned')
					}

					function renderWord () {

						dom(
							[cloud,
								//bounding-box
								/*['rect', {
								 width: element.width,
								 height: element.height,
								 style: 'fill: rgba(0,0,255,0.2)',
								 x: element.x,
								 y: element.y - element.height
								 }],*/
								['text', element.key, {
									class: 'vectual_tagcloud_text',
									style: 'font-size: ' + element.fontSize,
									x: element.x,
									y: element.y}
								]
							], svgNS
						)
					}

					try {
						if (index == 0) {
							element.x = element.y = 0
						}
						else {
							calculatePosition()
						}
						renderWord()
						return true
					}
					catch (e) {
						console.log(e.message)
						return false
					}

				}

				config.data.every(drawWord)
			}

			calculatePoints()
			//drawSpiral()
			drawWords()
		}

		init()
		build()
	}


	vectual = function v (localConfig) {

		var i,
		    defs,
		    size,
		    text,
		    temp = [],
		    tuples = [],
		    key

		//Overwrite global with custom configuration
		for (key in localConfig)
			if (localConfig.hasOwnProperty(key))
				config[key] = localConfig[key]

		//Convert data to JSON
		if (!(config.data instanceof Array)) {
			for (i in config.data)
				if (config.data.hasOwnProperty(i))
					temp.push({key: i, value: config.data[i]})

			config.data = temp
		}

		config.keys = []
		config.values = []
		config.sorted = {
			keys: [],
			values: []
		}
		config.size = config.data.length
		config.totalValue = 0
		config.max = {}
		config.min = {}

		config.data.forEach(function (element, index) {

			//Set maximum and minimum value
			if (index == 0)
				config.max = config.min = element
			else if (element.value > config.max.value)
				config.max = element
			else if (element.value < config.min.value)
				config.min = element

			//get sum of all values
			config.totalValue += Number(element.value)

			config.keys.push(element.key)
			config.values.push(element.value)

			//get sortable array
			tuples.push([element.key, element.value])

		})

		//sort array
		tuples.sort(function (a, b) {
			return a[1] < b[1] ? 1 : a[1] > b[1] ? -1 : 0
		})

		//split into key/value arrays
		tuples.forEach(function (element) {
			config.sorted.keys.push(element[0])
			config.sorted.values.push(element[1])
		})

		config.range = config.max.value - config.min.value


		svg = dom(
			['svg', {
				version: "1.1",
				class: (config.inline) ? 'vectual_inline' : 'vectual',
				width: config.width,
				height: config.height,
				viewBox: "0 0 " + config.width + " " + config.height},
				['defs',
					['linearGradient#rect_background', {
						x1: '0%',
						y1: '0%',
						x2: '0%',
						y2: '100%'},
						['stop', {
							offset: '0%',
							style: 'stop-color:rgb(80,80,80); stop-opacity:1'
						}],
						['stop', {
							offset: '0%',
							style: 'stop-color:rgb(40,40,40); stop-opacity:1'
						}]
					],
					['filter#dropshadow',
						['feGaussianBlur', {
							in: 'SourceAlpha',
							stdDeviation: 0.5,
							result: 'blur'
						}],
						['feOffset', {
							in: 'blur',
							dx: '2',
							dy: '2',
							result: 'offsetBlur'
						}],
						['feComposite', {
							in: 'SourceGraphic',
							in2: 'offsetBlur',
							result: 'origin'
						}]
					]
				],
				['rect', {
					class: 'vectual_background',
					x: 0,
					y: 0,
					width: config.width,
					height: config.height,
					rx: config.inline ? '' : 10,
					ry: config.inline ? '' : 10
				}],
				['text', config.title, {
					class: 'vectual_title',
					x: 20,
					y: (10 + config.height * 0.05),
					style: 'font-size:' + (config.height * 0.05) + 'px'
				}]
			]
			, svgNS
		)[0]


		console.log(config)
		document
			.getElementById(config.id)
			.appendChild(svg)


		return {
			pieChart: function () {
				return new Pie()
			},
			lineChart: function () {
				return new Line()
			},
			barChart: function () {
				return new Bar()
			},
			tagCloud: function () {
				return new Tagcloud()
			}
		}
	}


}(window, document)
