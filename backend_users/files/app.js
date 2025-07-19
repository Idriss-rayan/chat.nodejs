const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
app.use(express.json());

const filePath = path.join(__dirname, 'data', 'notes.txt');

const dataDir = path.join(__dirname, 'data');
if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir);
}

app.post('/notes', (req, res) => {
  const { message } = req.body;
  if (!message) return res.status(400).json({ error: 'Message vide' });

  const timestamp = new Date().toLocaleString(); 
  const noteLine = `[${timestamp}] ${message}\n`;

  fs.appendFile(filePath, noteLine, (err) => {
    if (err) return res.status(500).json({ error: "Erreur d'écriture du fichier" });
    res.json({ message: 'Note ajoutée avec succès' });
  });
});

app.get('/notes', (req, res) => {
  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) return res.status(500).json({ error: "Erreur de lecture du fichier" });
    res.json({ content: data });
  });
});

app.delete('/notes', (req, res) => {
  fs.unlink(filePath, (err) => {
    if (err) return res.status(500).json({ error: "Fichier non supprimé ou inexistant" });
    res.json({ message: "Fichier supprimé avec succès" });
  });
});

app.listen(3000, () => {
  console.log('✅ Serveur en ligne sur http://localhost:3000');
});
