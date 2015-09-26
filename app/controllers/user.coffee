##
# User pages for Candidates
# - Login required
##

module.exports = (app)->
	class app.UserController

		@editProfile: (req, res)->
			testCandidate =
				name: 'John Doe'
				election: '2015 Presidential Election'
				about: 'I am a nice person.'
				dob: '1975-09-22'

			res.render 'user/profile',
				title: 'Edit Profile'
				candidate: testCandidate

		@questions: (req, res)->
			res.render 'index',
				title: 'Hello'
				
			testQuestions = [
				{ asker: "Alice", text: "How are you today?" }
				{ asker: "Bob", text: "Do you like pies?" }
			]

			res.render 'user/questions',
				title: 'Answer Questions'
				questions: testQuestions
