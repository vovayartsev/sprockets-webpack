# Sprockets + Webpack

**Experimental**

A Sprockets directive that integrates Webpack.

## Usage

``` ruby
# Gemfile
gem 'sprockets', '>= 3.0.0'
gem 'sprockets-webpack'
```

```bash
rails g webpack:install
```

This will generate a sample `webpack.config.js` and `index.js`:

## What's next?

* configure `config/webpack.config.js`
* install more packages, e.g. `npm install react --save`  (remember to restart Rails server after that)
* require installed packages in index.js using ES6 syntax, e.g. `import React from 'react';`
* notice `webpack://` domain in *Sources* tab in Chrome Dev Tools

## Manual Setup

1. Put your config into `config/webpack.config.js`. Omit *entry* and *output* sections - they will be generated automatically
2. Put your JS sources e.g. into `app/assets/webpack`, create `index.js` there
3. In your *application.js* put `//= require_webpack_tree <path-to-js-folder>`

Webpack will be executed automatically when you run Rails in development environment, or when you run `rake assets:precompile` in production.

## Different webpack.conf.js in production?
You can customize your [webpack.js.conf](https://github.com/vovayartsev/sprockets-webpack/blob/master/lib/generators/webpack/install/templates/config/webpack.config.js) based on NODE_ENV environment variable
which is exposed to webpack.js.conf and defaults to your Rails env. E.g.
```js
if (process.env.NODE_ENV == 'development') {
  config.devtool = '#eval-source-map';
}
```

## Heroku

Deployment to Heroku works out of the box. Use two buildpacks: *nodejs* and *ruby*, in this order:
```bash
heroku buildpacks:add heroku/nodejs
heroku buildpacks:add heroku/ruby
```

Then exclude *node_modules* directory from both Git repo (using .gitignore)
and Heroku slug (using .slugignore)


## Caveates

All of the Webpack sources should reside under the single folder which contains a file named **index.js**, which is an entry point for your Webpack bundle.
