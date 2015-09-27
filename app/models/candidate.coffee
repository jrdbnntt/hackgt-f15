##
# User database access
##

table =
	name: 'Candidate' 
	col:
		id: 'id'
		userId: 'userId'
		firstName: 'firstName'
		lastName: 'lastName'
		dob: 'dob'
		about: 'about'
		pictureUrl: 'pictureUrl'
		
module.exports = (app)->
	class app.models.Candidate
		
		@create: (data)->
			dfd = app.Q.defer()
			id = null
			qcnt = 0
			
			con = app.db.newMultiCon()
			con.query 'INSERT INTO Candidate (userId,firstName,lastName,dob,pictureUrl) '+
			'VALUES (?,?,?,?,?); SELECT LAST_INSERT_ID() AS id;', [	
				data.userId
				data.firstName
				data.lastName
				data.dob
				data.about
				data.pictureUrl
			]
			.on 'result', (res)->
				++qcnt
				res.on 'row', (row)->
					if qcnt == 2
						id = parseInt row.id
			.on 'error', (err)->
				console.log 'DB ERR: ' + table.name + ' create ' + err
				dfd.reject err
			.on 'end', ()->
				dfd.resolve id
			con.end()
					
			return dfd.promise
		