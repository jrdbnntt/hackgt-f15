##
# Loads the data from the static json files into the app
##

module.exports = (app)->
	dataDir = app.dirs.base += '/lib/data';
	
	app.data = app.locals.data =
		# Site specific data
		roles: [
			{id: 0, name: 'Guest'}
			{id: 1, name: 'Candidate'}
			{id: 2, name: 'Admin'}
		]
		
		# Political data
		states:
			hash: require(dataDir + '/states_hash.json')
			titleCase: require(dataDir + '/states_titleCase.json')
		
		countiesByState: require(dataDir + '/counties.json')
		
		govLevels: [
			{id: 0, name: 'Local'}
			{id: 1, name: 'State'}
			{id: 2, name: 'Federal'}
		]
		
		electionTypes: [
			{id: 0, name: 'Primary'}
			{id: 1, name: 'General'}
			{id: 2, name: 'Midterm'}
		]
		
		officePositions: [
			{id: 0, name: 'President'}
			{id: 1, name: 'State Senator'}
			{id: 2, name: 'Mayor'}
			{id: 3, name: 'County Commissioner'}
		]
		
		