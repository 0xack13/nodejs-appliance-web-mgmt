// tools.js to define all external function that will be called by routes.coffee
var exec = require('child_process').exec;

module.exports = {
  foo: function () {
		console.log("\n\n ******* I'm here!!! *********** \n\n");
		spawn = require('child_process').spawn;
		ping_child = spawn('ping', ["8.8.4.4", ">>", '/ping-output.txt']);
		
		
  },
  bar: function () {
    ls.stdout.on('data', function (data) {    // register one or more handlers
	  console.log('stdout: ' + data);
	});
  },

};

var zemba = function () {
}
