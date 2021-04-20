const express = require('express')
const app = express()

const host = process.env.HOST || '127.0.0.1'
const port = process.env.PORT || '3000'

app.get('/', (request, response) => {
    response.send('Hello from Express!')
})
app.listen(port, host, (err) => {
    if (err) {
        return console.log('Something bad happened', err)
    }
    console.log('Server is listening on ' + host + ':' + port)
})
