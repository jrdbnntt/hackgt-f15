##
# User database access
##

User =
	name: 'User' 
	col:
		id: 'id'
		roleId: 'roleId'
		email: 'email'
		password: 'password'
		

module.exports = (app)->
	class app.models.User
		
		@create = (data)->
			dfd = app.Q.defer()
			
			# Encrypt password
			app.bcrypt.genSalt 10, (err, salt)->
				app.bcrypt.hash data.password, salt, (err, hash)->
					con = app.db.newCon()
					con.query 'INSERT INTO ? (?,?,?) VALUES (?,?,?)', [
						User.name
						
						User.col.roleId
						User.col.email
						User.col.password
						
						(data.roleId || 0)
						data.email
						hash
					]
					.on 'error', (err)->
						console.log('DB ERR: ' + User.name + ' create');
						dfd.reject()
					.on 'end', ()->
						dfd.resolve()
					con.end()
					
			return dfd.promise