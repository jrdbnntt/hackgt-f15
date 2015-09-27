##
# Public pages
##

module.exports = (app)->
	class app.PublicController

		@index: (req, res)->
			res.render 'index',
				title: 'Home'
				zipCode: req.session.zipCode

		@index_submit: (req, res)->
			req.session.zipCode = req.body.zipCode

			res.send {}

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
			if !req.body.email? || !req.body.password?
				res.send
					error: 'No email or password'
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
			# Get parties
			title = 'Sign Up'
			
			app.models.Party.getAll()
			.then (parties)->	
				res.render 'public/signup',
					title: title
					parties: parties
			, (err)->
				res.render 'public/signup',
					title: title
					parties: []
		
		@signup_submit: (req, res)->
			input = null
			form = new app.formiddable.IncomingForm()
			form.parse req, (err, fields, files)->
				input = fields
				if err
					res.json
						err: err
					return
			
			form.on 'end', (fields, files)->
				srcPath = this.openedFiles[0].path
				fileName = app.models.User.genFileName this.openedFiles[0].name
				dstLocation = app.dirs.static + '/img/static'
				app.fs.move srcPath, dstLocation + fileName
				, (err)->
					if err
						res.json
							error: 'Problem moving image'
						return
				
					if !(input.partyId? || input.partyName?) ||
					!(input.electionId? || input.electionData?) ||
					!input.email? ||
					!input.password? ||
					!input.firstName? ||
					!input.lastName? ||
					!input.dob? ||
					!input.about? ||
					!this.openedFiles.length == 0
						res.json
							err: 'Invalid parameters'
						return
					
					# Create the user, then the candidate
					app.models.User.create 
						email: input.email
						password: input.password
						roleId: 0
					.then (userId)->
						console.log 'user created: ' + userId
						app.models.Candidate.create
							userId: userId
							firstName: input.firstName
							lastName: input.lastName
							dob: input.dob
							about: input.about
							pictureUrl: fileName
						.then (candidateId)->
							console.log 'Candidate created: ' + input.fileName +' '+ input.lastName
							res.json
								candidateId: candidateId
						, (err)->
							res.json
					, (err)->
						res.json
							error: err
					
		@electionDateSearch: (req, res)->
			if !req.body.typeId? ||
			!req.body.levelId?
				res.json
					error: 'Invalid params'
			
			app.models.Election.getDateByInfo req.body
			.then (elections)->
				console.log elections
				res.json
					elections: elections
			, (err)->
				res.json
					error: err
	