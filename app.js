
/**
 * Module dependencies.
 */

require('coffee-script');
var flash = require('connect-flash');
var util  = require('util'),
    spawn = require('child_process').spawn,
    ls    = spawn('ls', ['-lh', '/usr']); // the second arg is the command 


var tools = require('./apps/authentication/controllers/tools');

/*var sys   = require('sys'),
    spawn = require('child_process').spawn,
    ls    = spawn('ls', ['-lh', '/usr']);

ls.stdout.on('data', function (data) {
  sys.print('stdout: ' + data);
});

ls.stderr.on('data', function (data) {
  sys.print('stderr: ' + data);
});

ls.on('exit', function (code) {
  console.log('child process exited with code ' + code);
});
*/
var express = require('express')
  	, RedisStore = require('connect-redis')(express)
	, http = require('http');

var app = express();
//var io = socket.listen(app);

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger());
  app.use(express.bodyParser());
  app.use(express.cookieParser('keyboard cat'));
  app.use(express.session({
	secret: "dfdfdfdfdfdfdfdf",
	store: new RedisStore,
	cookie: { maxAge: 60000 }
  }));
  app.use(express.static(__dirname + '/public'));
  app.use(express.methodOverride());
  app.use(flash());
  app.use(require('connect-flash')());
  // Expose the flash function to the view layer
  app.use(function(req, res, next) {
    res.locals.flash = function() { return req.flash() };
    next();
  })
  app.use(app.router);
});

app.get('/', function(req, res){
  res.render('index', { message: req.flash('info') });
});


app.configure('development', function(){
  app.use(express.errorHandler({ showStack: true}));
});

require('./apps/helpers')(app);

//Helpers
require('./apps/authentication/routes')(app);

//app.get('/', routes.index);

/*app.get('/flash', function(req, res){
  req.flash('info', 'Flash is back!')
  res.redirect('/');
});*/



var server = http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

io = module.exports = require('socket.io').listen(server);
