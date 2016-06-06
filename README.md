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
* require installed packages, e.g. `import React from 'react';`
* notice `webpack://` domain in *Sources* tab in Chrome Dev Tools

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
