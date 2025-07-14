const express = require('express');
const cors = require('cors');
const bodyparser = require('body-parser');
const { v4: uuidv4 } = require('uuid');

const app = express();
app.use(cors());
app.use(bodyparser.json());

let contact = [];

// ➕ POST /users
app.post('/users', (req, res) => {
    const { name, email } = req.body;

    if (!name || !email) {
        return res.status(400).json({ message: 'Nom et email requis' });
    }

    const id = uuidv4(); 
    const newUser = { id, name, email };
    contact.push(newUser);

    res.status(201).json(newUser);
});

app.get('/users', (req, res) => {
    res.json(contact);
});

app.listen(3000, () => {
    console.log('✅ Server listening on port 3000...');
});
