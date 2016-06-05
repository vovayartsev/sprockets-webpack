// Your package.json should include related packages
// Remember to run npm install before starting Rails app
var config = {
    module: {
      loaders: [
        {
          test: /\.jsx?$/,
          exclude: /(node_modules|bower_components)/,
          loader: 'babel',
          query: {
            presets: ['es2015', 'react']
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
