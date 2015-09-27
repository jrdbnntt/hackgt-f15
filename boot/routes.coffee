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
	# app.use acl

	###########################################################
	# Public pages

	# Home
	app.get '/', app.PublicController.index
	app.get '/home', app.PublicController.index
	app.get '/index', app.PublicController.index

	# Candidate Signin
	app.get '/signin', app.PublicController.signin
	app.post '/signin', jsonParser, app.PublicController.signin_submit

	# Candidate Signup
	app.get '/signup', app.PublicController.signup
	app.post '/signup', app.PublicController.signup_submit

	# Election browser for all
	app.get '/election', app.PublicController.electionBrowse

	# Election description for single
	# app.get '/election/:electionId', app.PublicController.electionView

	# Election issue browser
	# app.get '/election/:electionId/issue', app.PublicController.issueBrowse

	# Election issue view single
	# app.get '/election/:electionId/issue/:issueId', app.PublicController.issueView

	# Election crowdsource question handling
	# app.post '/election/question/new', jsonParser, app.PublicController.questionNew
	# app.post '/election/question/rate', jsonParser, app.PublicController.questionRate

	# Election search
	app.post '/election/dateSearch', jsonParser, app.PublicController.electionDateSearch


	# Candidate Browser
	app.get '/candidate', app.PublicController.candidateBrowse

	# Candidate View for single one
	# app.get '/candidate/:candidateId', app.PublicController.candidateView



	###########################################################
	# User pages

	# Signout (redirect to /)
	# app.get '/user/signout', app.UserController.signout

	# Edit Profile
	app.get '/user/edit/profile', app.UserController.editProfile
	# app.post '/user/edit/profile', jsonParser, app.UserController.editProfile_submit

	# Answer Questions
	app.get '/user/questions', app.UserController.questions
	# app.post '/user/questions', jsonParser, app.UserController.questions_submit


	###########################################################
	# Admin pages

	# Candidate Confirmation
	# app.get '/admin/accountRequests', app.AdminController.accountRequests
	# app.post '/admin/accountRequests', jsonParser, app.AdminController.accountRequests_submit

	# Manage questions
	app.get '/admin/questions', app.AdminController.questions
	# app.post '/admin/questions', app.AdminController.questions_submit


	###########################################################
	# Special pages

	# Error 404
	app.get '*', (req, res)->
		res.status(404)
		res.render '404',
			title: '404 Page Not Found'
