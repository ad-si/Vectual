import vectual from './vectual.js'
import config from './config.js'
import fruitConsumption from '../../tests/fixtures/fruit-consumption.js'

config.data = fruitConsumption

document.body.append(
  vectual(config)
    .pieChart(),
)

document.body.append(
  vectual(config)
    .barChart(),
)

document.body.append(
  vectual(config)
    .lineChart(),
)

// document.body.append(
//   vectual(config)
//     .tagCloud()
// )

// document.body.append(
//   vectual(config)
//     .scatterChart()
// )
//
// document.body.append(
//   vectual(config)
//     .map()
// )
//
// document.body.append(
//   vectual(config)
//     .table()
// )
