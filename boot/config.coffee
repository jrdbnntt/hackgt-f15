##
# Main app setup for global usage
##

# Modules
Q = require 'q'
util = require 'util'
path = require 'path'
morgan = require 'morgan'
session = require 'express-session'

# Local lib
autoload = require '../lib/autoload'

module.exports = (app)->
	# Save module references
	app.Q = Q
	app.util = util
	app.path = path
	app
		
	# Setup project
	app.env = process.env
	app.set 'port', app.env.PORT || 5000 
	app.set 'views', app.path.resolve __dirname + '/../app/views'
	app.set 'view engine', 'jade'
	app.use app.express.static app.path.resolve __dirname + '/../public'
	
	app.use morgan 'dev'
	
	app.use session 
		name: 'connect.sid'
		secret: app.env.SECRET + ' '
		cookie:
			maxAge: 172800000		#2 days
		saveUninitialized: false
		resave: false
	app.use (req,res,next) ->
		res.locals.session = req.session;
		next();
	
	
	# Load app into project
	autoload 'app/models', app
	autoload 'app/controllers', app