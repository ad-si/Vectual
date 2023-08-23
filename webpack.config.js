/* eslint-disable-next-line @typescript-eslint/no-var-requires */
const path = require('path')

module.exports = {
  mode: 'production',
  entry: './src/javascript/index.js',
  devtool: 'inline-source-map',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'build'),
  },
}
