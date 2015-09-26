##
# All app access routes
##

acl = require '../lib/acl'
bodyParser = require 'body-parser'

module.exports = (app)->
	# Body parsers
	jsonParser = bodyParser.json()
	urlencodedParser = bodyParser.urlencoded
		extended: false
	
	# Enforce the ACL
	app.use acl
	
	###########################################################
	# Public pages
	
	# Home
	app.get '/', app.PublicController.index
	app.get '/home', app.PublicController.index
	app.get '/index', app.PublicController.index
	
	
	
	###########################################################
	# User pages
	
	
	###########################################################
	# Admin pages
	
	
	
	###########################################################
	# Special pages
	
	
	app.get '*', (req, res)->
		res.status(404)
		res.render '404', 
			title: '404 Page Not Found'