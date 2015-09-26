##
# Public pages
##

module.exports = (app)->
	class app.PublicController

		@index: (req, res)->
			res.render 'index',
				title: 'Home'
				zipCode: req.session.zipCode

		@candidateBrowse: (req, res)->
			testCandidates = [
				{ name: "John Doe", election: "2016 Presidential Election" }
				{ name: "Jane Doe", election: "2015 Normaltown Mayoral Election" }
			]

			res.render 'public/candidate',
				title: 'Candidates'
				candidates: testCandidates

		@electionBrowse: (req, res)->
			testElections = [
				{ name: "2016 Presidential Election", level: "federal", date: "October 10th, 1953" }
				{ name: "2030 Normaltown Mayoral Election", level: "local", date: "May 29th, 2340" }
			]

			res.render 'public/election',
				title: 'Elections'
				elections: testElections

		@signin: (req, res)->
			res.render 'public/signin',
				title: 'Sign In'

		@signin_submit: (req, res)->
			if !req.body.email? ||
			!req.body.password?
				res.send
					error: 'Invalid params'
				return
			
			app.models.User.checkSignin req.body.email, req.body.password
			.then (userData)->
				console.log 'User login success: ' + userData.email
				
				req.session.user = userData
				
				res.send {}
			, (err)->
				res.send
					error: err

		@signup: (req, res)->
			res.render 'public/signup',
				title: 'Sign Up'

		@signup_submit: (req, res)->
			req.session.zipCode = req.body.zipCode

			res.send {}