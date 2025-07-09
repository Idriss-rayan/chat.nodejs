const express = require('express');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

let users = [];

// method de recuperation ...
app.get('/api/users', (req, res) => {
  res.json(users);
});

app.post('/api/users', (req, res) => {
  const { name, email } = req.body;
  const newUser = {
    id: Date.now().toString(),
    name,
    email,
  };
  users.push(newUser);
  res.status(201).json(newUser);
});

app.listen(port, () => {
  console.log(`✅ Serveur Node.js en ligne sur http://localhost:${port}`);
});
