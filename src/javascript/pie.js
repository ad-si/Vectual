import shaven from 'shaven'
import toRad from './toRad.js'

const svgNS = 'http://www.w3.org/2000/svg'


export default function (svg, config) {
  const radius = Math.min(config.height, config.width * 0.2)
  let lastx = -radius
  let lasty = 0
  let angleAll = 0
  const pie = shaven(
    ['g', {
      transform: 'translate(' +
        [0.5 * config.width, 0.5 * config.height].join() + ')',
    }], svgNS,
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
        svgNS,
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
          svgNS,
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
          }], svgNS,
        )[0]

        title = shaven(
          ['title',
            config.sorted.keys[index] + ' | ' +
              config.sorted.values[index] + ' | ' +
              Math.round(config.sorted.values[index] /
                          config.totalValue * 100)  + '%',
          ], svgNS,
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
          ], svgNS,
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
          ], svgNS,
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
          ], svgNS,
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
          ], svgNS,
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
        ], svgNS,
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
