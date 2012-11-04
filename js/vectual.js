(function (window, document, undefined) {
	var svg, //SVG DOM-fragment
		svgNS = "http://www.w3.org/2000/svg", //SVG namespace
		dom = DOMinate, //DOM-building utility
		c = { //Default configuration
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
		};

	function toRad(degrees) {
		return degrees * (Math.PI / 180);
	}

	function Pie() {
		var circle,
			text,
			radius = Math.min(c.height, c.width * 0.2),
			lastx = -radius,
			lasty = 0,
			angle_all = 0,
			pie = dom(
				['g', {
					'transform': 'translate(' + (0.5 * c.width) + ', ' + (0.5 * c.height) + ')'
				}], svgNS
			);


		function init() {
			dom([svg, [pie]]);
		}

		function build() {

			function drawSector(element, i) {
				var position,
					angle_all_rad,
					angle_all_last,
					angle_this,
					angle_translate,
					angle_add,
					trans_deg,
					tx,
					ty,
					sector,
					size,
					path,
					ani,
					text,
					animate,
					title,
					nextx,
					nexty;

				if (((c.sorted.values[i] / c.totalValue) * 360) > 180)
					size = '0 1,0';
				else
					size = '0 0,0';

				//Angle
				angle_all_last = angle_all;
				angle_this = ((c.sorted.values[i] / c.totalValue) * 360);
				angle_all = angle_this + angle_all;
				angle_all_rad = toRad(angle_all);

				//Shift direction of sector: add previous angle to half of the current
				angle_add = angle_this / 2;
				trans_deg = angle_all_last + angle_add;
				angle_translate = toRad(trans_deg);

				tx = -(Math.cos(angle_translate)) * radius;
				ty = (Math.sin(angle_translate)) * radius;

				nextx = -(Math.cos(angle_all_rad) * radius);
				nexty = (Math.sin(angle_all_rad) * radius);

				position = (trans_deg <= 75) ? 'end' : (trans_deg <= 105) ? 'middle' :
					(trans_deg <= 255) ? 'start' : (trans_deg <= 285) ? 'middle' : 'end';


				sector = dom(
					[pie,
						['g', {'class': "vectual_pie_sector"}]
					]
					, svgNS);

				/*Not working
				 if (c.animations) {
				 dom(
				 [sector,
				 ['animateTransform', {
				 attributeName: 'transform',
				 begin: 'mouseover',
				 type: 'translate',
				 to: (tx * 0.2) + ', ' + (ty * 0.2),
				 dur: '1s',
				 additive: 'replace',
				 fill: 'freeze'
				 }],
				 ['animateTransform', {
				 attributeName: 'transform',
				 begin: 'mouseout',
				 type: 'translate',
				 to: '0,0',
				 dur: '1s',
				 additive: 'replace',
				 fill: 'freeze'
				 }]
				 ], svgNS
				 );
				 }
				 */

				path = dom(
					['path', {
						'class': 'vectual_pie_sector_path',
						'style': 'stroke-width:' + (radius * 0.015) + ';fill:' + c.colors[i],
						'd': 'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + nextx + ',' + nexty + ' z'}
					]
					, svgNS);

				dom([sector, [path]]);


				if (c.animations) {

					dom(
						[path,
							['animate', {
								'attributeName': 'opacity',
								'from': '0',
								'to': '1',
								'dur': '0.6s',
								'fill': 'freeze'}
							],
							['animateTransform', {
								'attributeName': 'transform',
								'type': 'rotate',
								'dur': '1s',
								'calcMode': 'spline',
								'keySplines': '0 0 0 1',
								'values': angle_all_last + ',0,0; 0,0,0',
								'additive': 'replace',
								'fill': 'freeze'}
							]
						]
						, svgNS);
				}

				text = dom(
					['text', {
						'class': 'vectual_pie_text',
						'x': (tx * 1.2),
						'y': (ty * 1.2),
						'text-anchor': position,
						'style': 'font-size:' + (angle_this * radius * 0.002 + 8) + 'px',
						'fill': c.colors[i],
						'transform': 'translate(0, 5)'
					}], svgNS
				);

				dom([sector, [text]]);


				if (c.animations) {

					dom(
						[text,
							['animate', {
								'attributeName': 'opacity',
								'begin': '0s',
								'values': '0;0;1',
								'dur': '1s',
								'fill': 'freeze'}
							]
						]
						, svgNS);
				}

				dom(
					[sector,
						['title',
							c.sorted.keys[i] + ' | ' +
								c.sorted.values[i] + ' | ' +
								(Math.round(c.sorted.values[i] / c.totalValue * 100) ) + '%'
						]
					]
					, svgNS);

				lastx = nextx;
				lasty = nexty;
			}

			//Draw circle if only one value
			if (c.totalValue == c.max.value)
				dom(
					[pie,
						['circle', {
							'class': 'vectual_pie_sector',
							'cx': '0',
							'cy': '0',
							'r': radius,
							'fill': c.colors[1]
						}],
						['text', c.max.key, {
							'class': 'vectual_pie_text_single, vectual_pie_text',
							'x': '0',
							'y': '0',
							'style': 'font-size:' + (radius * 0.3) + 'px',
							'text-anchor': 'middle',
							'stroke-width': (radius * 0.006)
						}]
					], svgNS
				);
			else
				c.data.forEach(drawSector);

		}

		init();
		build();
	}

	function Bar() {

		var yDensity = 0.1,
			yRange = (c.max.value - c.min.value),
			a,
			g,
			i,
			line,
			text,
			graphHeight = c.height * 0.8,
			graphWidth = c.width * 0.95,
			coSysHeight = c.height * 0.6,
			coSysWidth = c.width * 0.85,
			bars = dom(
				['g', {
					transform: 'translate(' + (graphWidth * 0.1) + ', ' + graphHeight + ')'
				}], svgNS
			);

		function init() {
			dom([svg, [bars]]);

		}

		function build() {

			function drawBar(element, i) {

				var bar = dom(
					['rect', {
						'class': 'vectual_bar_bar',
						'x': (i * (coSysWidth / c.size)),
						'y': -(c.values[i] - c.min.value) * (coSysHeight / yRange),
						'height': (c.values[i] - c.min.value) * (coSysHeight / yRange),
						'width': (0.7 * (coSysWidth / c.size)) },
						['title', c.keys[i] + ':  ' + c.values[i]]
					]
					, svgNS);

				bars.appendChild(bar);

				if (c.animations) {

					dom(
						[bar,
							['animate', {
								'attributeName': 'height',
								'from': '0',
								'to': (c.values[i] - c.min.value) * (coSysHeight / yRange),
								'begin': '0s',
								'dur': '1s',
								'fill': 'freeze'}
							],
							['animate', {
								attributeName: 'y',
								from: '0',
								to: -(c.values[i] - c.min.value) * (coSysHeight / yRange),
								begin: '0s',
								dur: '1s',
								fill: 'freeze'}
							],
							['animate', {
								'attributeName': 'opacity',
								'from': '0',
								'to': '0.8',
								'begin': '0s',
								'dur': '1s',
								'fill': 'freeze',
								'additive': 'replace'}
							],
							['animate', {
								'attributeName': 'fill',
								'to': 'rgb(100,210,255)',
								'begin': 'mouseover',
								'dur': '0.1s',
								'fill': 'freeze',
								'additive': 'replace'}
							],
							['animate', {
								'attributeName': 'fill',
								'to': 'rgb(0,150,250)',
								'begin': 'mouseout',
								'dur': '0.2s',
								'fill': 'freeze',
								'additive': 'replace'}
							]
						]
						, svgNS);
				}
			}

			function drawCoordinateSystem() {

				function ordinates() {

					var cssClass;

					for (var i = 0; i < c.size; i++) {

						cssClass = (i == 0) ? 'vectual_coordinate_axis_y' : 'vectual_coordinate_lines_y';

						dom(
							[bars,
								['line', {
									'class': cssClass,
									'x1': (coSysWidth / c.size) * i,
									'y1': '5',
									'x2': (coSysWidth / c.size) * i,
									'y2': -coSysHeight
								}],
								['text', c.keys[i], {
									'class': 'vectual_coordinate_labels_x',
									'transform': 'rotate(40 ' + ((coSysWidth / c.size) * i) + ', 10)',
									'x': ((coSysWidth / c.size) * i),
									'y': '10'}
								]
							]
							, svgNS);

					}
				}

				function abscissas() {

					var styleClass, line, text;

					for (var i = 0; i <= (yRange * yDensity); i++) {

						styleClass = (i == 0) ? 'vectual_coordinate_axis_x' : 'vectual_coordinate_lines_x';

						dom(
							[bars,
								['line', {
									'class': styleClass,
									'x1': '-5',
									'y1': -(coSysHeight / yRange) * (i / yDensity),
									'x2': coSysWidth,
									'y2': -(coSysHeight / yRange) * (i / yDensity) }
								],
								['text', i / yDensity + c.min.value, {
									'class': 'vectual_coordinate_labels_y',
									'x': -coSysWidth * 0.05,
									'y': -(coSysHeight / yRange) * (i / yDensity)}
								]
							]
							, svgNS);

					}
				}

				abscissas();
				ordinates();
			}

			drawCoordinateSystem();
			c.data.forEach(drawBar);
		}

		init();
		build();
	}

	function Line() {

		var yDensity = 0.1,
			yRange = (c.max.value - c.min.value),
			g,
			text,
			graphWidth = c.width * 0.95,
			graphHeight = c.height * 0.8,
			coSysWidth = c.width * 0.85,
			coSysHeight = c.height * 0.6,
			graph = dom(
				['g', {
					'transform': 'translate(' + (graphWidth * 0.1) + ', ' + (graphHeight) + ')'
				}], svgNS
			);

		function init() {
			dom([svg, [graph]]);
		}

		function build() {

			function drawCoordinateSystem() {

				function horizontalLoop() {

					var cssClass, line;

					for (var i = 0; i < c.size; i++) {

						cssClass = (i == 0) ? 'vectual_coordinate_axis_y' : 'vectual_coordinate_lines_y';

						dom(
							[graph,
								['line', {
									'class': cssClass,
									'x1': (coSysWidth / c.size) * i,
									'y1': 5,
									'x2': (coSysWidth / c.size) * i,
									'y2': -coSysHeight}
								],
								['text', c.keys[i], {
									'class': 'vectual_coordinate_labels_x',
									'transform': 'rotate(40 ' + ((coSysWidth / c.size) * i) + ', 10)',
									'x': ((coSysWidth / c.size) * i),
									'y': '10'}
								]
							]
							, svgNS);

					}
				}

				function verticalLoop() {

					var styleClass,
						line,
						text;

					for (var i = 0; i <= (yRange * yDensity); i++) {

						styleClass = (i == 0) ? 'vectual_coordinate_axis_x' : 'vectual_coordinate_lines_x';

						dom(
							[graph,
								['line', {
									'class': styleClass,
									'x1': -5,
									'y1': -(coSysHeight / yRange) * (i / yDensity),
									'x2': coSysWidth,
									'y2': -(coSysHeight / yRange) * (i / yDensity)
								}],
								['text', i / yDensity + c.min.value, {
									'class': 'vectual_coordinate_labels_y',
									'x': -coSysWidth * 0.05,
									'y': -(coSysHeight / yRange) * (i / yDensity)
								}]
							]
							, svgNS);

					}
				}

				horizontalLoop();
				verticalLoop();
			}

			function buildLine() {

				var points = '',
					pointsTo = '',
					line,
					a;

				for (var i = 0; i < c.size; i++) {
					points += (i * (coSysWidth / c.size)) + ',0 ';
				}

				for (var j = 0; j < c.size; j++) {
					pointsTo += (j * (coSysWidth / c.size)) + ',' + ((-c.values[j] + c.min.value) * (coSysHeight / yRange)) + ' ';
				}

				line = graph.appendChild(document.createElementNS(svgNS, 'polyline'));
				line.setAttribute('class', 'vectual_line_line');
				line.setAttribute('points', pointsTo);


				if (c.animations) {

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
						, svgNS);

				}
			}

			function setDots() {

				var circle,
					a;

				for (var i = 0; i < c.size; i++) {

					circle = dom(
						['circle', {
							'class': 'vectual_line_dot',
							'r': '4',
							'cx': i * (coSysWidth / c.size),
							'cy': (-c.values[i] + c.min.value) * (coSysHeight / yRange)}

							, ['title', c.keys[i] + ':  ' + c.values[i]]
						]
						, svgNS);


					graph.appendChild(circle);


					if (c.animations) {

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
							, svgNS);

					}
				}

			}

			drawCoordinateSystem();
			buildLine();
			setDots();
		}

		init();
		build();
	}

	function Tagcloud() {

		var minFontsize = 10, //minimum font-size
			until = 300, //size of spiral
			factor = 10, //resolution improvement
			density = 0.2, //density of spiral
			xySkew = 0.6, //elliptical shape of spiral (0 < xySkew < 1)
			cloud = dom(
				['g', {
					transform: 'translate(' + (0.5 * c.width) + ', ' + (0.5 * c.height) + ')',
					class: 'vectualTagcloud'
				}], svgNS
			);

		function init() {

			c.data.forEach(function (element) {

				//font-size
				element.fontSize = minFontsize + ((c.height * 0.1) * (element.value - c.min.value)) / (c.max.value - c.min.value);

				//bounding-box
				element.height = element.fontSize * 0.8;
				element.width = element.key.length * element.fontSize * 0.5;
			});

			dom([svg, [cloud]]);
		}

		function build() {

			var pointsNumber = until * factor * density,
				points = [],
				i,
				b,
				u,
				x,
				y,
				pos_x = [],
				pos_y = [],
				area_x = [],
				area_y = [];

			function calculatePoints() {

				for (i = 0; i < pointsNumber; i++) {
					b = i * (1 / factor);

					x = -(1 / density) * xySkew * b * Math.cos(b);
					y = -(1 / density) * (1 - xySkew) * b * Math.sin(b);

					points.push({x: x, y: y});
				}
			}

			function drawSpiral() {

				var string = '';

				points.forEach(function (point) {
					string += point.x + ',' + point.y + ' '
				});

				dom(
					[cloud,
						['polyline', {
							points: string,
							style: 'fill: none; stroke:red; stroke-width:1'
						}]
					]
					, svgNS
				);
			}

			function drawWords() {

				function drawWord(element, index) {

					function calculatePosition() {

						//returns true if point was found and saves it in element
						function testPoint(point, pointIndex) {

							function notOverlapping(formerElement, formerIndex) {

								//if element is already set
								if (formerElement.x !== undefined) {

									return point.x > formerElement.x + formerElement.width //right
										|| point.x < formerElement.x - element.width //left
										|| point.y < formerElement.y - formerElement.height //above
										|| point.y > formerElement.y + element.height; //beyond

								} else {
									return true;
								}

							}

							//test if every element is not overlapping
							if (c.data.every(notOverlapping) == true) {
								element.x = point.x;
								element.y = point.y;
								return true;
							} else {
								return false;
							}
						}

						if (points.some(testPoint) == false)
							throw new Error('Element could not be positioned');
					}

					function renderWord() {

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
						);
					}

					try {
						if (index == 0) {
							element.x = element.y = 0;
						} else {
							calculatePosition();
						}
						renderWord();
						return true;
					} catch (e) {
						console.log(e.message);
						return false;
					}

				}

				c.data.every(drawWord);
			}

			calculatePoints();
			//drawSpiral();
			drawWords();
		}

		init();
		build();
	}


	vectual = function v(config) {

		var i,
			a,
			defs,
			size,
			text,
			temp = [],
			tuples = [];

		//Overwrite global with custom configuration
		for (a in config) {
			if (config.hasOwnProperty(a))
				c[a] = config[a];
		}

		//Convert data to JSON
		if (!(c.data instanceof Array)) {
			for (i in c.data) {
				if (c.data.hasOwnProperty(i))
					temp.push({key: i, value: c.data[i]});
			}

			c.data = temp;
		}

		c.keys = [];
		c.values = [];
		c.sorted = {
			keys: [],
			values: []
		};
		c.size = c.data.length;
		c.totalValue = 0;
		c.max = {};
		c.min = {};

		c.data.forEach(function (element, index) {

			//Set maximum and minimum value
			if (index == 0)
				c.max = c.min = element;
			else if (element.value > c.max.value)
				c.max = element;
			else if (element.value < c.min.value)
				c.min = element;

			//get sum of all values
			c.totalValue += Number(element.value);

			c.keys.push(element.key);
			c.values.push(element.value);

			//get sortable array
			tuples.push([element.key, element.value]);

		});

		//sort array
		tuples.sort(function (a, b) {
			return a[1] < b[1] ? 1 : a[1] > b[1] ? -1 : 0
		});

		//split into key/value arrays
		tuples.forEach(function (element) {
			c.sorted.keys.push(element[0]);
			c.sorted.values.push(element[1]);
		});

		c.range = c.max.value - c.min.value;

		console.log(c);

		//--------------------------------------------------------

		svg = dom(
			['svg', {
				version: "1.1",
				class: (c.inline) ? 'vectual_inline' : 'vectual',
				width: c.width,
				height: c.height,
				viewBox: "0 0 " + c.width + " " + c.height},
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
					width: c.width,
					height: c.height,
					rx: c.inline ? '' : 10,
					ry: c.inline ? '' : 10
				}],
				['text', c.title, {
					class: 'vectual_title',
					x: 20,
					y: (10 + c.height * 0.05),
					style: 'font-size:' + (c.height * 0.05) + 'px'
				}]
			]
			, svgNS);


		dom([document.getElementById(c.id) , [svg]]);

		return {
			pieChart: function () {
				return new Pie();
			},
			lineChart: function () {
				return new Line();
			},
			barChart: function () {
				return new Bar();
			},
			tagCloud: function () {
				return new Tagcloud();
			}
		};
	}


}(window, document));