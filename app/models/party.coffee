##
# Party database access
##

table =
	name: 'Party' 
	col:
		id: 'id'
		name: 'name'

module.exports = (app)->
	class app.models.Party
		
		@create: (name)->
			dfd = app.Q.defer()
			id = null
			qcnt = 0
			
			con = app.db.newMultiCon()
			con.query 'INSERT INTO ? (?) VALUES (?); SELECT LAST_INSERT_ID() AS id;', [
				table.name
				
				table.col.name
				name
			]
			.on 'result', (res)->
				++qcnt
				res.on 'row', (row)->
					if qcnt == 2
						id = parseInt row.id
			.on 'error', (err)->
				console.log('DB ERR: ' + table.name + ' create ' + err);
				dfd.reject err
			.on 'end', ()->
				dfd.resolve id
			con.end()
			
			return dfd.promise
		
		@getAll: ()->
			dfd = app.Q.defer()
			results = []
			
			con = app.db.newCon()
			con.query 'SELECT * FROM ' + table.name
			.on 'result', (res)->
				res.on 'row', (row)->
					results.push
						id: parseInt row.id
						name: row.name
			.on 'error', (err)->
				console.log('DB ERR: ' + table.name + ' getAll ' + err);
				dfd.reject err
			.on 'end', ()->
				dfd.resolve results
			con.end()
			
			return dfd.promise
		