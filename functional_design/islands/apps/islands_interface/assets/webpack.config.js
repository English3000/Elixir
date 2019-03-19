const path                    = require('path'),
      glob                    = require('glob'),
      UglifyJsPlugin          = require('uglifyjs-webpack-plugin'),
      OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin'),
      MiniCssExtractPlugin    = require('mini-css-extract-plugin'),
      CopyWebpackPlugin       = require('copy-webpack-plugin'),
      { CheckerPlugin }       = require('awesome-typescript-loader'),
      ErrorOverlayPlugin      = require('error-overlay-webpack-plugin')

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
    new CheckerPlugin(),
    new ErrorOverlayPlugin(),
  ],
  resolve: {
    alias: {
      'react-native$':    'react-native-web',
      'react-native-svg': 'svgs'
    },
    extensions: ['.js', '.jsx', '.ts', '.tsx']
  }
});
