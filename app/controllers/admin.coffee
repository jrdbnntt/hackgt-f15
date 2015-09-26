##
# Admin management pages for admins
# - Login required 
##

module.exports = (app)->
	class app.AdminController

		@questions: (req, res)->
			testQuestions = [
				{ asker: "Alice", text: "How are you today?" }
				{ asker: "Bob", text: "Do you like pies?" }
			]

			res.render 'user/questions',
				title: 'Answer Questions'
				questions: testQuestions