const path = require('path')

module.exports = {
  entry: './source/index.js',
  devtool: 'inline-source-map',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'build'),
  },
}
