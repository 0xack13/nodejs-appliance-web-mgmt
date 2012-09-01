tools = require('./controllers/tools');
exec = require('child_process').exec;

dir_list = (cb) ->
	  #sys = require("sys")
	  #exec = require("child_process").exec
	  #child = exec("traceroute -d google.com", (error, stdout, stderr) ->

	    #I would like to return stdout but can't figure out how
	   # cb stdout
	util = require("util")
	spawn = require("child_process").spawn
	ls = spawn("ls", ["-lh", "/usr"])
	cb ls



routes = (app) ->
	app.get "/ifconfig", (req, res) ->
		spawn = require("child_process").spawn
		killallping = spawn("killall", ["ping"])
		#child = exec('ifconfig | grep \"inet \" | grep -v 127.0.0.1 | cut -d\\  -f2', (error, stdout, stderr) ->
		buffer
		lines
		child = exec('ping -c 3 cisco.com', (error, stdout, stderr) ->
		    res.render "#{__dirname}/views/ifconfig", result: stdout
		)
		#ifconfig = spawn("ifconfig")
		#ifconfig.stdout.on "data", (data) ->
		#	io.sockets.emit "log", data.toString("utf8")
		return

	app.get '/flash', (req, res) ->
		req.flash 'info', 'flash is back!'
		res.redirect '/'
	
	app.get '/', (req, res) ->
		res.render('index', { message: req.flash('info') })
	
	app.get '/login', (req, res) ->
		res.render "#{__dirname}/views/login",
			title: 'Login'
			stylesheet: 'login';
	
	app.get "/traceroute", (req, res) ->
		exec('killall traceroute', ->
			res.render "#{__dirname}/views/traceroute"
		)
		return
	
	app.post "/traceroute", (req, res) ->
		#spawn = require("child_process").spawn
		#tail = spawn("traceroute", ["google.com"])
		
		#tail.stdout.on "data", (data) ->
		#  io.sockets.emit "log", data.toString("utf8")
		#res.render "#{__dirname}/views/traceroute"
		#return
		exec("killall traceroute", (error, stdout, stderr) ->
			spawn = require("child_process").spawn
			tail = spawn("traceroute", [req.body.ip])
			tail.stdout.setEncoding('utf-8')
			
			tail.stdout.on "data", (data) ->
				io.sockets.emit "log", data.toString()
				res.render "#{__dirname}/views/traceroute"
				return
			
			tail.stderr.setEncoding('utf-8')
			tail.stderr.on "data", (data) ->
				console.log data
				msg = data
				io.sockets.emit "log", data.toString()
				res.render "#{__dirname}/views/traceroute", {msg: msg}
				return
		)	
		
		
	app.get "/ping", (req, res) ->
		exec('killall ping', ->
			res.render "#{__dirname}/views/ping"
		)
		return

	app.get "/chart", (req, res) ->
		res.render "#{__dirname}/views/chart", {latitude: "test"}
		return

	app.post "/ping", (req, res) ->
		exec("killall ping", (error, stdout, stderr) ->
			spawn = require("child_process").spawn
			tail = spawn("ping", [req.body.ip])
			tail.stdout.setEncoding('utf-8')
			tail.stdout.on "data", (data) ->
				io.sockets.emit "log", data.toString()
				res.render "#{__dirname}/views/ping"
				return
			tail.stderr.setEncoding('utf-8')
			tail.stderr.on "data", (data) ->
				console.log "\n\n &&&&& ERROR in Ping"
				msg = "Please check that you entered correct URL and that you're connected properly to your network. "
				io.sockets.emit "log", data.toString()
				res.render "#{__dirname}/views/ping", {msg: msg}
				return
		)	
	
	app.post '/sessions', (req, res) ->
		if ('s' is req.body.user) and ('1' is req.body.password)
			req.session.currentUser = req.body.user
			req.flash();
			req.flash 'info', "Logged in as #{req.body.user}!"
			res.render("#{__dirname}/views/wizard", {info: req.flash('info')})
			return
		req.flash();
		req.flash 'error', 'Failed to login on the given username and password. Please try again!'
		res.render("#{__dirname}/views/login", { error: req.flash('error')})
		return
	
	app.get "/wizard", (req, res) ->
		util = require("util")
		spawn = require("child_process").spawn
		ls = spawn("ping", ["localhost"])
		
		ls.stdout.on "data", (data) ->
		  console.log "stdout: " + data
		  res.render "#{__dirname}/views/wizard",
		      title: "MyPage"
		      subtitle: "Below is a directory listing"
		      results: data
		

		
	app.get '/some', (req, res) ->
		console.log(typeof tools.foo)
		#tools.foo()
		#spawn = require('child_process').spawn;
		#ping_child = spawn('ping', ["8.8.4.4", "|", 'tee', '/ping-output.txt']);
		
		#tail_child = spawn('tail', ['-f', '/ping-output.txt']);
		#tail_child.stdout.on 'data', (data) ->
			#console.log(data.toString())
			#console.log(typeof tools.zemba)
		#res.write (data)
		
		#res.render "#{__dirname}/views/wizard"
		
		
		spawn = require("child_process").spawn
		# everytime there is a new request, spawn an child process
		tail_child = spawn("ping", ["www.google.com"])

		# kill tail_child everytime the connection ends to keep from many processes being created
		req.connection.on "end", ->
		  tail_child.kill()


		# observe the output by binding to the data event
		#
		# because javascript is not good at handling buffers, use the function for buffering data
		tail_child.stdout.on "data", (data) ->

		  # write it on the console
		  console.log data.toString()
		  res.write data
		

		  # send it to the browser because the browser will be waiting for the next chunk of data
		  #req.session.data1 = data
		  #res.render "#{__dirname}/views/wizard"
		    #data: "data"
			#(err, html) ->
		  	#	res.send html
			
		
	

# export modules			
module.exports = routes
