const express = require('express');
const cors = require('cors');
const bodyparser = require('body-parser');
const { v4: uuidv4 } = require('uuid');

const app = express();
app.use(cors());
app.use(bodyparser.json());

let contact = [];

app.use((req, res, next) => {
  const now = new Date();
  const heure = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  console.log(`${req.method} ${req.path} à ${heure}`);
  next();
});
// Middleware centralisé de gestion d'erreurs
app.use((err, req, res, next) => {
  console.error('❌ Erreur attrapée :', err.message);

  res.status(err.status || 500).json({
    error: true,
    message: err.message || 'Erreur interne du serveur',
  });
});

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
app.get('/users/search', (req, res) => {
  const nameQuery = req.query.name;

  if (!nameQuery) {
    return res.status(400).json({ message: 'Le paramètre "name" est requis' });
  }

  const results = contact.filter(user =>
    user.name.toLowerCase().includes(nameQuery.toLowerCase())
  );

  res.json(results); // Retourne un tableau vide si aucun résultat
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