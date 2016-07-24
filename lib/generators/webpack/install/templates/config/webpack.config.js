// Your package.json should include related packages
// Remember to run npm install before starting Rails app

var webpack = require('webpack');

var config = {
    // entry: .....   <--- ignored, will default to app/assets/webpack/index.js
    // output: ...    <--- ignored, the output will be sent through Sprockets pipeline
    module: {
      loaders: [
        {
          test: /\.jsx?$/,
          exclude: /(node_modules|bower_components)/,
          loader: 'babel',
          query: {
            presets: ['es2015']
          }
        }
      ]
    }
};

// if NODE_ENV not set, it defaults to Rails.env (for Rails apps) or ENV['RACK_ENV'].
// Otherwise it's always "development"
if (process.env.NODE_ENV == 'development') {
  config.devtool = '#eval-source-map';
}

module.exports = config;
