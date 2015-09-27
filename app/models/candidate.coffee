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
	class app.models.Candidate
		
		@list: (data)->
			dfd = app.Q.defer()
			
			# data.electionId
			setTimeout ()->
				testCandidates = [
					{ name: "John Doe", election: "2016 Presidential Election" }
					{ name: "Jane Doe", election: "2015 Normaltown Mayoral Election" }
				]
				dfd.resolve(testQuestions)
			, 50
			
			return dfd.promise