const path = require('path')

module.exports = {
  entry: './src/javascript/index.js',
  devtool: 'inline-source-map',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'build'),
  },
  mode: 'production',
}
