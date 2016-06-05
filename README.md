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

## Caveates

All of the Webpack sources should reside under the single folder which contains
a file named **index.js**, which is an entry point for your Webpack bundle.
