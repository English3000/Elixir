const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const { CheckerPlugin } = require('awesome-typescript-loader')
// https://www.typescriptlang.org/docs/handbook/react-&-webpack.html
module.exports = (env, options) => ({
  devtool: 'source-map',
  optimization: {
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: {
    // './js/app.tsx': ['./js/app.tsx'].concat(glob.sync('./vendor/**/*.js'))
    './js/app.js': ['./js/app.js'].concat(glob.sync('./vendor/**/*.js'))
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      { test: /\.tsx?$/, loader: 'awesome-typescript-loader' },
      { test: /\.jsx?$/, exclude: /node_modules/, enforce: 'pre', loader: 'source-map-loader' },
      { test: /\.jsx?$/, exclude: /node_modules/, use: {loader: 'babel-loader'} },
      { test: /\.css$/, use: [MiniCssExtractPlugin.loader, 'css-loader'] }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }]),
    new CheckerPlugin()
  ],
  resolve: {
    alias: {
      'react-native$': 'react-native-web',
      'react-native-svg': 'svgs'
    },
    extensions: ['.js', '.jsx', '.ts', '.tsx']
  }
});
