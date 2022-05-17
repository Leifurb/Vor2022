const express = require('express');
const app = express();

const hostname = '127.0.0.1';
const port = 3000;

// Import a body parser module to be able to access the request body as json
const bodyParser = require('body-parser');
//Tell express to use the body parser module
app.use(bodyParser.json());

let users = [];
let nextUserId = 1;

app.get('/', (req, res) => {
    res.status(200).send('Hello World!');
});

app.post('/users', (req, res) => {
    if (req.body.username === undefined) {
        return res.status(400).json({'message':'No username defined.'}); 
    }
    let newUser = {username: req.body.username, age: req.body.age, id:nextUserId};
    users.push(newUser);
    nextUserId++;
    res.status(201).json(newUser);
});

app.listen(port, hostname, () => {
    console.log('Express app listening on port ' + port);
});