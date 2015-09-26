##
# Main boot script
##

express = require('express')

app = express()
app.express = express

# Load the setup
require('./config')(app)
require('./routes')(app)

# Launch the server
app.listen app.get('port'), ()->
	console.log 'Server listening on port ' + app.get('port')