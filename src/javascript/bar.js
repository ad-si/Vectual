import shaven from 'shaven'

const svgNS = 'http://www.w3.org/2000/svg'


export default function (svg, config) {
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
    }], svgNS,
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
          ], svgNS,
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
          ], svgNS,
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
        svgNS,
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
          ], svgNS,
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
      svgNS,
    )
  }

  function inject () {
    shaven(
      [svg,
        [barchart,
          [coordinateSystem],
          [bars],
        ],
      ],
    )
  }

  buildCoordinateSystem()
  buildBars()
  if (config.animations) setAnimations()
  inject()

  return svg
}
