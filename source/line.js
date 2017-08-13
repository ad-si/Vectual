import shaven from 'shaven'

const svgNS = 'http://www.w3.org/2000/svg'


export default function (svg, config) {
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
