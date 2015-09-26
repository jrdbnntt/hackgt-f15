##
# Public pages
##

module.exports = (app)->
	class app.PublicController

		@index = (req, res)->
			res.render 'index',
				title: 'Home'

		@electionBrowse = (req, res)->
			res.render 'public/election',
				title: 'Elections'
				elections: testElections

testElections = [
	{ name: "2016 Presidential Election", level: "federal" }
	{ name: "2015 Normaltown Mayoral Election", level: "local" }
]

