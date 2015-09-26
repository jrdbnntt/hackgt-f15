##
# Public pages
##

module.exports = (app)->
	class app.PublicController

		@index: (req, res)->
			res.render 'index',
				title: 'Home'

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
				{ name: "2016 Presidential Election", level: "federal" }
				{ name: "2015 Normaltown Mayoral Election", level: "local" }
			]
			
			res.render 'public/election',
				title: 'Elections'
				elections: testElections

		@signin: (req, res)->
			res.render 'public/signin', 
				title: 'Sign In'
			
