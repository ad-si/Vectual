import shaven from 'shaven'

const svgNS = 'http://www.w3.org/2000/svg'


export default function (svg, config) {
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
