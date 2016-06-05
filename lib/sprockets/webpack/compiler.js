var webpack = require("webpack");
var readline = require('readline');
var configFullPath = require.resolve(process.argv[2]);

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

function prepareConfig() {
  delete require.cache[configFullPath];
  var config = require(configFullPath);
  config.entry = process.argv[3];
  config.output = {
    path: process.argv[4],
    filename: process.argv[5]
  };
  return webpack(config);
}

var compiler = prepareConfig();

rl.on('line', function(line) {
  if (line.trim() == 'RELOAD') {
    compiler = prepareConfig();
  }

  compiler.run(function(err, stats) {
    if (err) {
      console.log("FATAL", err);
    }

    var jsonStats = stats.toJson();

    if (jsonStats.errors.length > 0) {
      console.log("WEBPACK ERRORS");
      printArray(jsonStats.errors);
    }

    if (jsonStats.warnings.length > 0) {
      console.log("WEBPACK WARNINGS");
      printArray(jsonStats.warnings);
    }

    console.log("WEBPACK::EOF");
  });
});

function printArray(arr) {
  arr.forEach(function(item) {
    console.log(item);
  });
}
