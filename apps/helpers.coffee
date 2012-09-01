helpers = (app) ->	
	app.locals (req, res) ->
		res.locals.session = req.session
module.exports = helpers