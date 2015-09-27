##
# Question database access
##

table =
	name: 'User' 
	col:
		id: 'id'
		roleId: 'roleId'
		email: 'email'
		password: 'password'
		

module.exports = (app)->
	class app.models.Question
		
		@create: (data)->
			dfd = app.Q.defer()

			setTimeout ()->
				dfd.resolve()
			, 50
			
			return dfd.promise

		@list: (data)->
			# data.electionId
			setTimeout ()->
				testQuestions = [
					{ asker: 'Alice', score: 1000, qid: 1, text: "What's up?" }
					{ asker: 'Bob', score: 500, qid: 5, text: "Do you like pizza?" }
					{ asker: 'Charlie', score: 250, qid: 10, text: "How is life?" }
				]
				dfd.resolve(testQuestions)
			, 50
			
		
		@rate: (data)->
			dfd = app.Q.defer()
			
			setTimeout ()->
				dfd.resolve()
			, 50
			
			return dfd.promise
		
