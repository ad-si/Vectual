import shaven from 'shaven'
import pie from './pie.js'
import line from './line.js'
import bar from './bar.js'
import tagCloud from './tagCloud.js'

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
    pieChart: () => {
      return pie(svg, config)
    },
    lineChart: () => {
      return line(svg, config)
    },
    barChart: () => {
      return bar(svg, config)
    },
    tagCloud: () => {
      return tagCloud(svg, config)
    },
  }
}
