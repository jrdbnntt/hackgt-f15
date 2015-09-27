##
# Election database access
##

table =
	name: 'Election' 
	col:
		id: 'id'
		typeId: 'typeId'
		levelId: 'levelId'
		position: 'position'
		description: 'description'
		state: 'state'
		county: 'county'
		date: 'date'
		
module.exports = (app)->
	class app.models.Election
		
		@getDateByInfo: (data)->
			dfd = app.Q.defer()
			results = []
			q = null
			console.log data
			
			con = app.db.newCon()
			switch data.levelId
				when 2
					q = con.query 'SELECT ?,?,? FROM Election WHERE ?=? && ?=?', [
						table.col.id
						table.col.position
						table.col.date
						
						table.col.typeId, data.typeId
						table.col.levelId, data.levelId
					]
				when 1 
					q = con.query 'SELECT ?,?,? FROM Election WHERE ?=? && ?=? && ?=?', [
						table.col.id
						table.col.position
						table.col.date
						
						table.col.typeId, data.typeId
						table.col.levelId, data.levelId
						table.col.state, data.state
					]
				when 0 
					q = con.query 'SELECT ?,?,? FROM Election WHERE ?=? && ?=? && ?=? && ?=?', [
						table.col.id
						table.col.position
						table.col.date
						
						table.col.typeId, data.typeId
						table.col.levelId, data.levelId
						table.col.state, data.state
						table.col.county, data.county
					]
						
			q.on 'result', (res)->
				res.on 'row', (row)->
					results.push
						id: parseInt row.id
						position: row.position
						date: row.date
			.on 'error', (err)->
				console.log 'DB ERR: ' + table.name + ' dateSearch ' + err
				dfd.reject err
			.on 'end', ()->
				dfd.resolve results
			con.end()
			
			return dfd.promise