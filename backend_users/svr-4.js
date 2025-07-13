const express = require('express');
const cors = require('cors');
const bodyparser = require('body-parser');

const app = express();

app.use(cors());
app.use(bodyparser.json()); 

let contact = [];

app.post('/', (req, res) => {
  const { name, id, number } = req.body;
  contact.push({ name, id, number });
  res.status(201).json({ message: 'Contact added successfully' }); 
});

const existing = contact.find(c => c.id == id);
if (existing){
    return res.status(409).json({message: 'message already exist '})
}

contact.push({ name, id, number });
  res.status(201).json({ message: 'Contact added successfully' });

app.get('/', (req, res) => {
  res.json(contact); 
});

app.listen(3000, () => {
  console.log('Server listening on port 3000');
});
