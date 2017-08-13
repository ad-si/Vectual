import shaven from 'shaven'

let svg
const svgNS = 'http://www.w3.org/2000/svg'
const config = {
  id: 'demo',
  title: 'vectual.js',
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
    'brown',
  ],
}

function toRad (degrees) {
  return degrees * (Math.PI / 180)
}

function Pie () {
  const radius = Math.min(config.height, config.width * 0.2)
  let lastx = -radius
  let lasty = 0
  let angleAll = 0
  const pie = shaven(
    ['g', {
      transform: 'translate(' +
        [0.5 * config.width, 0.5 * config.height].join() + ')',
    }], svgNS
  )[0]


  function init () {
    shaven([svg, [pie]])
  }

  function build () {

    function drawSector (element, index) {
      let position
      const angleAllLast = angleAll
      const angleThis = (config.sorted.values[index] / config.totalValue) * 360
      const angleAdd = angleThis / 2
      let angleAllRad
      const transDeg = angleAllLast + angleAdd
      const angleTranslate = toRad(transDeg)
      const tx = -Math.cos(angleTranslate) * radius
      const ty = Math.sin(angleTranslate) * radius
      let path
      let text
      let title
      let nextx
      let nexty
      const size =
        ((config.sorted.values[index] / config.totalValue) * 360) > 180
          ? '0 1,0'
          : '0 0,0'
      const sector = shaven(
        ['g', {class: 'vectual_pie_sector'}],
        svgNS
      )[0]


      function localInit () {
        // Angle
        angleAll = angleThis + angleAll
        angleAllRad = toRad(angleAll)

        nextx = -(Math.cos(angleAllRad) * radius)
        nexty = Math.sin(angleAllRad) * radius

        position =
        transDeg <= 75
          ? 'end'
          : transDeg <= 105
            ? 'middle'
            : transDeg <= 255
              ? 'start'
              : transDeg <= 285
                ? 'middle'
                : 'end'
      }

      function localBuild () {
        path = shaven(
          ['path', {
            class: 'vectual_pie_sector_path',
            style: 'stroke-width:' + (radius * 0.015) +
                     ';fill:' + config.colors[index],
            d: // eslint-disable-line id-length
              'M 0,0 L ' + lastx + ',' + lasty +
              ' A ' + radius + ',' + radius + ' ' + size + ' ' +
                 nextx + ',' + nexty + ' z',
          }],
          svgNS
        )[0]

        text = shaven(
          ['text', {
            class: 'vectual_pie_text',
            x: tx * 1.2, // eslint-disable-line id-length
            y: ty * 1.2, // eslint-disable-line id-length
            'text-anchor': position,
            style: 'font-size:' +
                     (angleThis * radius * 0.002 + 8) + 'px',
            fill: config.colors[index],
            transform: 'translate(0, 5)',
          }], svgNS
        )[0]

        title = shaven(
          ['title',
            config.sorted.keys[index] + ' | ' +
              config.sorted.values[index] + ' | ' +
              Math.round(config.sorted.values[index] /
                          config.totalValue * 100)  + '%',
          ], svgNS
        )[0]

      }

      function setAnimations () {

        shaven(
          [sector,
            ['animateTransform', {
              attributeName: 'transform',
              begin: 'mouseover',
              type: 'translate',
              to: (tx * 0.2) + ', ' + (ty * 0.2),
              dur: '300ms',
              additive: 'replace',
              fill: 'freeze',
            }],
            ['animateTransform', {
              attributeName: 'transform',
              begin: 'mouseout',
              type: 'translate',
              to: '0,0',
              dur: '600ms',
              additive: 'replace',
              fill: 'freeze',
            }],
          ], svgNS
        )

        shaven(
          [path,
            ['animate', {
              attributeName: 'opacity',
              from: '0',
              to: '1',
              dur: '0.6s',
              fill: 'freeze',
            }],
            ['animateTransform', {
              attributeName: 'transform',
              type: 'rotate',
              dur: '1s',
              calcMode: 'spline',
              keySplines: '0 0 0 1',
              values: angleAllLast + ',0,0; 0,0,0',
              additive: 'replace',
              fill: 'freeze',
            }],
          ], svgNS
        )


        shaven(
          [text,
            ['animate', {
              attributeName: 'opacity',
              begin: '0s',
              values: '0;0;1',
              dur: '1s',
              fill: 'freeze',
            }],
          ], svgNS
        )

      }

      function inject () {
        shaven(
          [pie,
            [sector,
              [path],
              [text],
              [title],
            ],
          ], svgNS
        )
      }

      localInit()
      localBuild()
      if (config.animations) setAnimations()
      inject()

      lastx = nextx
      lasty = nexty
    }

    // Draw circle if only one value
    if (config.totalValue === config.max.value)      {
      shaven(
        [pie,
          ['circle', {
            class: 'vectual_pie_sector',
            cx: '0',
            cy: '0',
            r: radius, // eslint-disable-line id-length
            fill: config.colors[1],
          }],
          ['text', config.max.key, {
            class: 'vectual_pie_text_single, vectual_pie_text',
            x: '0', // eslint-disable-line id-length
            y: '0', // eslint-disable-line id-length
            style: 'font-size:' + (radius * 0.3) + 'px',
            'text-anchor': 'middle',
            'stroke-width': radius * 0.006,
          }],
        ], svgNS
      )
    }
    else      {
      config.data.forEach(drawSector)
    }

  }

  init()
  build()

  return svg
}

function Bar () {

  const yDensity = 0.1
  const yRange = config.max.value - config.min.value
  const graphHeight = config.height * 0.8
  const graphWidth = config.width * 0.95
  const coSysHeight = config.height * 0.6
  const coSysWidth = config.width * 0.85
  const barchart = shaven(
    ['g', {
      transform: 'translate(' +
        [graphWidth * 0.1, graphHeight].join() +
      ')',
    }], svgNS
  )[0]
  const coordinateSystem = shaven(['g'], svgNS)[0]
  const bars = shaven(['g'], svgNS)[0]


  function buildCoordinateSystem () {
    function ordinates () {
      let cssClass
      let index

      for (index = 0; index < config.size; index++) {
        cssClass = index === 0
          ? 'vectual_coordinate_axis_y'
          : 'vectual_coordinate_lines_y'

        shaven(
          [coordinateSystem,
            ['line', {
              class: cssClass,
              x1: (coSysWidth / config.size) * index,
              y1: '5',
              x2: (coSysWidth / config.size) * index,
              y2: -coSysHeight,
            }],
            ['text', config.keys[index], {
              class: 'vectual_coordinate_labels_x',
              transform: 'rotate(40 ' +
                         ((coSysWidth / config.size) * index) +
                         ', 10)',
              // eslint-disable-next-line id-length
              x: (coSysWidth / config.size) * index,
              y: 10, // eslint-disable-line id-length
            }],
          ], svgNS
        )
      }
    }

    function abscissas () {
      let styleClass
      let index

      for (index = 0; index <= (yRange * yDensity); index++) {
        styleClass = index === 0
          ? 'vectual_coordinate_axis_x'
          : 'vectual_coordinate_lines_x'

        shaven(
          [coordinateSystem,
            ['line', {
              class: styleClass,
              x1: -5,
              y1: -(coSysHeight / yRange) * (index / yDensity),
              x2: coSysWidth,
              y2: -(coSysHeight / yRange) * (index / yDensity),
            }],
            ['text', String(index / yDensity + config.min.value), {
              class: 'vectual_coordinate_labels_y',
              x: -coSysWidth * 0.05, // eslint-disable-line id-length
              // eslint-disable-next-line id-length
              y: -(coSysHeight / yRange) * (index / yDensity),
            }],
          ], svgNS
        )
      }
    }

    abscissas()
    ordinates()
  }

  function buildBars () {
    function drawBar (element, index) {
      const height = config.animations
        ? 0
        : (config.values[index] - config.min.value) * (coSysHeight / yRange)
      const bar = shaven(
        ['rect',
          {
            class: 'vectual_bar_bar',
            // eslint-disable-next-line id-length
            x: index * (coSysWidth / config.size),
            // eslint-disable-next-line id-length
            y: -(config.values[index] - config.min.value) *
              (coSysHeight / yRange),
            height: height,
            width: 0.7 * (coSysWidth / config.size),
          },
          ['title', config.keys[index] + ':  ' + config.values[index]],
        ],
        svgNS
      )[0]

      function localSetAnimations () {
        shaven(
          [bar,
            ['animate', {
              attributeName: 'height',
              to: (config.values[index] - config.min.value) *
                (coSysHeight / yRange),
              begin: '0s',
              dur: '1s',
              fill: 'freeze',
            }],
            ['animate', {
              attributeName: 'y',
              from: 0,
              to: -(config.values[index] - config.min.value) *
                (coSysHeight / yRange),
              begin: '0s',
              dur: '1s',
              fill: 'freeze',
            }],
            ['animate', {
              attributeName: 'fill',
              to: 'rgb(100,210,255)',
              begin: 'mouseover',
              dur: '100ms',
              fill: 'freeze',
              additive: 'replace',
            }],
            ['animate', {
              attributeName: 'fill',
              to: 'rgb(0,150,250)',
              begin: 'mouseout',
              dur: '200ms',
              fill: 'freeze',
              additive: 'replace',
            }],
          ], svgNS
        )
      }

      function localInject () {
        shaven([bars, [bar]])
      }

      if (config.animations) localSetAnimations()
      localInject()
    }

    config.data.forEach(drawBar)
  }

  function setAnimations () {
    shaven(
      [bars,
        ['animate', {
          attributeName: 'opacity',
          from: 0,
          to: 0.8,
          begin: '0s',
          dur: '1s',
          fill: 'freeze',
          additive: 'replace',
        }],
      ],
      svgNS
    )
  }

  function inject () {
    shaven(
      [svg,
        [barchart,
          [coordinateSystem],
          [bars],
        ],
      ]
    )
  }

  buildCoordinateSystem()
  buildBars()
  if (config.animations) setAnimations()
  inject()

  return svg
}

function Line () {
  const yDensity = 0.1
  const yRange = config.max.value - config.min.value
  const graphWidth = config.width * 0.95
  const graphHeight = config.height * 0.8
  const coSysWidth = config.width * 0.85
  const coSysHeight = config.height * 0.6
  const graph = shaven(
    ['g', {
      transform: 'translate(' + (graphWidth * 0.1) + ', ' + graphHeight + ')',
    }], svgNS
  )[0]

  function init () {
    shaven([svg, [graph]])
  }

  function build () {
    function drawCoordinateSystem () {
      function horizontalLoop () {
        let cssClass

        for (let index = 0; index < config.size; index++) {
          cssClass = index === 0
            ? 'vectual_coordinate_axis_y'
            : 'vectual_coordinate_lines_y'

          shaven(
            [graph,
              ['line', {
                class: cssClass,
                x1: (coSysWidth / config.size) * index,
                y1: 5,
                x2: (coSysWidth / config.size) * index,
                y2: -coSysHeight,
              }],
              ['text', config.keys[index], {
                class: 'vectual_coordinate_labels_x',
                transform: 'rotate(40 ' +
                  ((coSysWidth / config.size) * index) + ', 10)',
                // eslint-disable-next-line id-length
                x: (coSysWidth / config.size) * index,
                y: 10, // eslint-disable-line id-length
              }],
            ], svgNS)

        }
      }

      function verticalLoop () {
        let styleClass

        for (let index = 0; index <= (yRange * yDensity); index++) {
          styleClass = index === 0
            ? 'vectual_coordinate_axis_x'
            : 'vectual_coordinate_lines_x'

          shaven(
            [graph,
              ['line', {
                class: styleClass,
                x1: -5,
                y1: -(coSysHeight / yRange) * (index / yDensity),
                x2: coSysWidth,
                y2: -(coSysHeight / yRange) * (index / yDensity),
              }],
              ['text', index / yDensity + config.min.value, {
                class: 'vectual_coordinate_labels_y',
                // eslint-disable-next-line id-length
                x: -coSysWidth * 0.05,
                // eslint-disable-next-line id-length
                y: -(coSysHeight / yRange) * (index / yDensity),
              }],
            ]
            , svgNS)

        }
      }

      horizontalLoop()
      verticalLoop()
    }

    function buildLine () {

      let points = ''
      let pointsTo = ''
      let index
      let index2

      for (index = 0; index < config.size; index++) {
        points += (index * (coSysWidth / config.size)) + ',0 '
      }

      for (index2 = 0; index2 < config.size; index2++) {
        pointsTo += (index2 * (coSysWidth / config.size)) + ',' +
                    ((-config.values[index2] + config.min.value) *
                     (coSysHeight / yRange)) + ' '
      }

      const shavenObject = shaven([graph,
        ['polyline.vectual_line_line$line', {
          points: pointsTo,
        }],
      ])

      const line = shavenObject.references.line


      if (config.animations) {
        shaven(
          [line,
            ['animate', {
              attributeName: 'points',
              from: points,
              to: pointsTo,
              begin: '0s',
              dur: '1s',
              fill: 'freeze'},
            ],
            ['animate', {
              attributeName: 'opacity',
              begin: '0s',
              from: '0',
              to: '1',
              dur: '1s',
              additive: 'replace',
              fill: 'freeze'},
            ],
          ],
          svgNS
        )
      }
    }

    function setDots () {
      let circle
      let index

      for (index = 0; index < config.size; index++) {

        circle = shaven(
          ['circle',
            {
              class: 'vectual_line_dot',
              r: '4', // eslint-disable-line id-length
              cx: index * (coSysWidth / config.size),
              cy: (-config.values[index] + config.min.value) *
                (coSysHeight / yRange),
            },
            ['title', config.keys[index] + ':  ' + config.values[index]],
          ]
          , svgNS)[0]


        graph.appendChild(circle)


        if (config.animations) {

          shaven(
            [circle,
              ['animate', {
                attributeName: 'opacity',
                begin: '0s',
                values: '0;0;1',
                keyTimes: '0;0.8;1',
                dur: '1.5s',
                additive: 'replace',
                fill: 'freeze',
              }],
              ['animate', {
                attributeName: 'r',
                to: '8',
                dur: '0.1s',
                begin: 'mouseover',
                additive: 'replace',
                fill: 'freeze',
              }],
              ['animate', {
                attributeName: 'r',
                to: '4',
                dur: '0.2s',
                begin: 'mouseout',
                additive: 'replace',
                fill: 'freeze'},
              ],
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

  return svg
}

function Tagcloud () {
  const minFontsize = 10 // minimum font-size
  const until = 300 // size of spiral
  const factor = 10 // resolution improvement
  const density = 0.2 // density of spiral
  const xySkew = 0.6 // elliptical shape of spiral (0 < xySkew < 1)
  const cloud = shaven(
    ['g', {
      transform: 'translate(' +
        (0.5 * config.width) + ', ' +
        (0.5 * config.height) + ')',
      class: 'vectualTagcloud',
    }], svgNS
  )[0]


  function init () {
    config.data.forEach((element) => {
      // font-size
      element.fontSize = minFontsize +
        ((config.height * 0.1) * (element.value - config.min.value)) /
        (config.max.value - config.min.value)

      // bounding-box
      element.height = element.fontSize * 0.8
      element.width = element.key.length * element.fontSize * 0.5
    })

    shaven([svg, [cloud]])
  }


  function build () {
    const pointsNumber = until * factor * density
    const points = []
    let index
    let bValue
    let xValue
    let yValue

    function calculatePoints () {
      for (index = 0; index < pointsNumber; index++) {
        bValue = index * (1 / factor)

        xValue = -(1 / density) * xySkew * bValue * Math.cos(bValue)
        yValue = -(1 / density) * (1 - xySkew) * bValue * Math.sin(bValue)

        points.push({
          x: xValue, // eslint-disable-line id-length
          y: yValue, // eslint-disable-line id-length
        })
      }
    }

    // function drawSpiral () {
    //   let string = ''
    //
    //   points.forEach((point) => {
    //     string += point.x + ',' + point.y + ' '
    //   })
    //
    //   shaven(
    //     [cloud,
    //       ['polyline', {
    //         points: string,
    //         style: 'fill: none; stroke:red; stroke-width:1',
    //       }],
    //     ]
    //     , svgNS
    //   )
    // }

    function drawWords () {
      function drawWord (element, wordIndex) {
        function calculatePosition () {
          // returns true if point was found and saves it in element
          function testPoint (point) {
            function notOverlapping (formerElement) {
              // if element is already set
              if (formerElement.x !== undefined) {
                return point.x > formerElement.x +
                    formerElement.width || // right
                  point.x < formerElement.x - element.width || // left
                  point.y < formerElement.y - formerElement.height || // above
                  point.y > formerElement.y + element.height // beyond
              }
              else {
                return true
              }
            }

            // test if every element is not overlapping
            if (config.data.every(notOverlapping) === true) {
              element.x = point.x // eslint-disable-line id-length
              element.y = point.y // eslint-disable-line id-length
              return true
            }
            else {
              return false
            }
          }

          if (!points.some(testPoint)) {
            console.error('Element could not be positioned')
          }
        }

        function renderWord () {

          shaven(
            [cloud,
              // bounding-box
              /* ['rect', {
               width: element.width,
               height: element.height,
               style: 'fill: rgba(0,0,255,0.2)',
               x: element.x,
               y: element.y - element.height
               }],*/
              ['text', element.key, {
                class: 'vectual_tagcloud_text',
                style: 'font-size: ' + element.fontSize,
                x: element.x, // eslint-disable-line id-length
                y: element.y, // eslint-disable-line id-length
              },
              ],
            ], svgNS
          )
        }

        try {
          if (wordIndex === 0) {
            element.x = element.y = 0 // eslint-disable-line id-length
          }
          else {
            calculatePosition()
          }
          renderWord()
          return true
        }
        catch (error) {
          console.error(error)
          return false
        }
      }

      config.data.every(drawWord)
    }

    calculatePoints()
    // drawSpiral()
    drawWords()
  }

  init()
  build()

  return svg
}


export default function (localConfig) {
  let index
  const temp = []
  const tuples = []
  let key

  // Overwrite global with custom configuration
  for (key in localConfig)    {
    if (localConfig.hasOwnProperty(key))      {
      config[key] = localConfig[key]
    }
  }

  // Convert data to JSON
  if (!(config.data instanceof Array)) {
    for (index in config.data)      {
      if (config.data.hasOwnProperty(index))        {
        temp.push({key: index, value: config.data[index]})
      }
    }

    config.data = temp
  }

  config.keys = []
  config.values = []
  config.sorted = {
    keys: [],
    values: [],
  }
  config.size = config.data.length
  config.totalValue = 0
  config.max = {}
  config.min = {}

  config.data.forEach((element, dataIndex) => {
    // Set maximum and minimum value
    if (dataIndex === 0)      {
      config.max = config.min = element
    }
    else if (element.value > config.max.value)      {
      config.max = element
    }
    else if (element.value < config.min.value)      {
      config.min = element
    }

    // get sum of all values
    config.totalValue += Number(element.value)

    config.keys.push(element.key)
    config.values.push(element.value)

    // get sortable array
    tuples.push([element.key, element.value])

  })

  // sort array
  tuples.sort((valueA, valueB) =>
    valueA[1] < valueB[1]
      ? 1
      : valueA[1] > valueB[1]
        ? -1
        : 0
  )

  // split into key/value arrays
  tuples.forEach((element) => {
    config.sorted.keys.push(element[0])
    config.sorted.values.push(element[1])
  })

  config.range = config.max.value - config.min.value


  svg = shaven(
    ['svg',
      {
        version: '1.1',
        class: config.inline ? 'vectual_inline' : 'vectual',
        width: config.width,
        height: config.height,
        viewBox: '0 0 ' + config.width + ' ' + config.height,
      },
      ['defs',
        ['linearGradient#rect_background',
          {
            x1: '0%',
            y1: '0%',
            x2: '0%',
            y2: '100%',
          },
          ['stop', {
            offset: '0%',
            style: 'stop-color:rgb(80,80,80); stop-opacity:1',
          }],
          ['stop', {
            offset: '0%',
            style: 'stop-color:rgb(40,40,40); stop-opacity:1',
          }],
        ],
        ['filter#dropshadow',
          ['feGaussianBlur', {
            in: 'SourceAlpha',
            stdDeviation: 0.5,
            result: 'blur',
          }],
          ['feOffset', {
            in: 'blur',
            dx: '2',
            dy: '2',
            result: 'offsetBlur',
          }],
          ['feComposite', {
            in: 'SourceGraphic',
            in2: 'offsetBlur',
            result: 'origin',
          }],
        ],
      ],
      ['rect', {
        class: 'vectual_background',
        x: 0, // eslint-disable-line id-length
        y: 0, // eslint-disable-line id-length
        width: config.width,
        height: config.height,
        rx: config.inline ? '' : 10,
        ry: config.inline ? '' : 10,
      }],
      ['text', config.title, {
        class: 'vectual_title',
        x: 20, // eslint-disable-line id-length
        y: 10 + config.height * 0.05, // eslint-disable-line id-length
        style: 'font-size:' + (config.height * 0.05) + 'px',
      }],
    ]
    , svgNS
  )[0]

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
    },
  }
}
