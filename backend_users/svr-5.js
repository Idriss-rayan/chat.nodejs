const express = require('express');
const cors = require('cors');
const bodyparser = require('body-parser');
const { v4: uuidv4 } = require('uuid');

const app = express();
app.use(cors());
app.use(bodyparser.json());

let contact = [];


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


app.delete('/users/:id', (req, res)=>{
    const id = req.params.id;
    const index = contact.findIndex(user => user.id === id);

    if (index !== -1){
        contact.splice(index, 1);
        res.status(200).json({ message: 'Utilisateur supprime' });
    } else {
        res.status(404).json({ message:'Utilisateur introuvable' });
    }
});

app.put('/users/:id', (req, res) => {
  const userId = req.params.id;
  const { name, email } = req.body;

  const index = contact.findIndex(user => user.id === userId);
  if (index !== -1) {
    contact[index] = { ...contact[index], name, email };
    res.status(200).json({ message: 'User updated', user: contact[index] });
  } else {
    res.status(404).json({ message: 'User not found' });
  }
});


app.listen(3000, () => {
    console.log('✅ Server listening on port 3000...');
});
