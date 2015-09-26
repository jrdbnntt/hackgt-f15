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
		
		@create: (data)->
			dfd = app.Q.defer()
			
			# Hash password
			app.bcrypt.genSalt 10, (err, salt)->
				app.bcrypt.hash data.password, salt, (err, hash)->
					userId = null
					qcnt = 0
					
					# Save new user
					con = app.db.newMultiCon()
					con.query 'INSERT INTO ? (?,?,?) VALUES (?,?,?); SELECT LAST_INSERT_ID() AS userId;', [
						table.name
						
						table.col.roleId
						table.col.email
						table.col.password
						
						roleId
						email
						hash
					]
					.on 'result', (res)->
						++qcnt
						res.on 'row', (row)->
							if qcnt == 2
								userId = parseInt row.userId
					.on 'error', (err)->
						console.log('DB ERR: ' + table.name + ' create');
						dfd.reject err
					.on 'end', ()->
						dfd.resolve userId
					con.end()
					
			return dfd.promise
		
		@checkSignin: (email, password)->
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
			
		@genFileName: (original)->
			original = original.replace(/\s/g,'_').replace(/[\W[^.]]/ig,'-')
			if original.length > 15
				original = original.substr original.length - 15
			
			rand = '' + Math.random().toString(32).substr(2) + 
				Math.random().toString(32).substr(2) + 
				Math.random().toString(32).substr(2) + 
				original.split("").reverse().join("").substr(0,20).split("").reverse().join("")
				
			if rand.length > 100
				start = rand.length - 100
				rand = rand.substr start
			return rand
			