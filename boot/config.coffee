##
# Main app setup for global usage
##

# Modules
Q = require 'q'
util = require 'util'
path = require 'path'
morgan = require 'morgan'
session = require 'express-session'
dotenv = require 'dotenv'
bcrypt = require 'bcrypt'
Mariasql = require 'mariasql'
formidable = require 'formidable'
fs = require 'fs-extra'

# Local lib
autoload = require '../lib/autoload'

module.exports = (app)->
	# Save module references
	app.Q = Q
	app.util = util
	app.path = path
	app.bcrypt = bcrypt
	app.formidable = formidable
	app.fs = fs
	
	
	app.dirs = {}
	app.dirs.base =  app.path.resolve __dirname + '/..'
	app.dirs.static = app.dirs.base + '/public'
	app.dirs.views = app.dirs.base + '/app/views'
		
	# Setup project
	dotenv.load()
	app.env = process.env
	
	app.set 'port', app.env.PORT || 5000 
	app.set 'views', app.dirs.views
	app.set 'view engine', 'jade'
	app.locals.pretty = true
	app.use app.express.static app.dirs.static
	
	app.use morgan 'dev'
	
	# HAndle user sessions
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
	
	# Setup db
	app.db = 
		Client: Mariasql
		setup:
			host: app.env.DATABASE_HOSTNAME
			port: app.env.DATABASE_PORT
			user: app.env.DATABASE_USERNAME
			password: app.env.DATABASE_PASSWORD
			db: app.env.DATABASE_NAME
	app.db.newCon = ()->
			con = new app.db.Client()
			con.connect app.db.setup
			con.on 'connect', ()->
				this.tId = this.threadId #so it isnt deleted
				# console.log '> DB: New connection established with threadId ' + this.tId
			.on 'error', (err)->
				console.log '> DB: Error on threadId ' + this.tId + '= ' + err
			.on 'close', (hadError)->
				if hadError
					console.log '> DB: Connection closed with old threadId ' + this.tId + ' WITH ERROR!'
				else
					# console.log '> DB: Connection closed with old threadId ' + this.tId + ' without error'
			return con
	app.db.newMultiCon = ()->
			config = app.db.setup
			config.multiStatements = true
			con = new app.db.Client()
			con.connect config
			con.on 'connect', ()->
				this.tId = this.threadId #so it isnt deleted
				# console.log '> DB: New connection established with threadId ' + this.tId
			.on 'error', (err)->
				console.log '> DB: Error on threadId ' + this.tId + '= ' + err
			.on 'close', (hadError)->
				if hadError
					console.log '> DB: Connection closed with old threadId ' + this.tId + ' WITH ERROR!'
				else
					# console.log '> DB: Connection closed with old threadId ' + this.tId + ' without error'
			return con
	
	# Load app into project
	app.models = {}
	autoload 'app/models', app
	autoload 'app/controllers', app