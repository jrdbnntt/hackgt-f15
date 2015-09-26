##
# User database access
##

table =
	name: 'User' 
	col:
		id: 'id'
		roleId: 'roleId'
		email: 'email'
		password: 'password'
		

module.exports = (app)->
	class app.models.User
		
		@create = (email, password, roleId = 0)->
			dfd = app.Q.defer()
			
			# Hash password
			app.bcrypt.genSalt 10, (err, salt)->
				app.bcrypt.hash password, salt, (err, hash)->
					
					# Save new user
					con = app.db.newCon()
					con.query 'INSERT INTO ? (?,?,?) VALUES (?,?,?)', [
						table.name
						
						table.col.roleId
						table.col.email
						table.col.password
						
						roleId
						email
						hash
					]
					.on 'error', (err)->
						console.log('DB ERR: ' + table.name + ' create');
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
			con.query 'SELECT ?,?,? FROM User WHERE ?=?', [						
				table.col.id
				table.col.roleId
				table.col.password
				
				table.name
				
				table.col.email, email
			]
			.on 'result', (res)->
				res.on 'row', (row)->
					storedPassword = row.password
					userData = 
						userId: parseInt row.id
						roleId: parseInt row.roleId
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
				console.log('DB ERR: ' + table.name + ' create: ' + err);
				dfd.reject err
			
			con.end()
				
			return dfd.promise
			
			