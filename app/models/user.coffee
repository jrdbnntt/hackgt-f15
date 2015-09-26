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
			
			# Hash password
			app.bcrypt.genSalt 10, (err, salt)->
				app.bcrypt.hash data.password, salt, (err, hash)->
					
					# Save new user
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
		
		@checkSignin = (email, password)->
			dfd = app.Q.defer()
			userData = null
			storedPassword = null

			con = app.db.newCon()
			con.query 'SELECT ?,? FROM ? WHERE ?=? LIMIT 1', [						
				User.col.id
				User.col.roleId
				User.col.password
				
				User.name
				
				User.col.email, email
			]
			.on 'result', (res)->
				res.on 'row', (row)->
					storedPassword = row.password
					userData = 
						userId: row.id
						roleId: row.roleId
						email: email
				
				res.on 'end', (info)->
					if info.numrows == 0
						console.log '[DB] login failure [bad email]: ' + email
						dfd.reject 'Invalid login credentials'
						return
					
					app.bcrypt.compare password, storedPassword, (err, res)->
						if err
							console.log '[DB] login failure [bad email]: ' + email
							dfd.reject 'Invalid login credentials'
							return
						
						# Success!
						dfd.resolve userData
			
			.on 'error', (err)->
				console.log('DB ERR: ' + User.name + ' create: ' + err);
				dfd.reject err
			
			con.end()
				
			return dfd.promise
			
			