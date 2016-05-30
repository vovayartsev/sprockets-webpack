var webpack = require("webpack");
var config = require(process.argv[2]);
var readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

config.entry = process.argv[3];
config.output = {
  path: process.argv[4],
  filename: process.argv[5]
};

var compiler = webpack(config);

rl.on('line', function(line) {
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
