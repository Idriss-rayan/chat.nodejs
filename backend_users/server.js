const express = require('express');
const bodyparser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors())
app.use(bodyparser.json());

app.post('/', (req, res) => {
    const { name , number } = req.body;
    console.log('Nom recu: ', name);
    console.log('Numero recu: ', number);

    res.json({message: 'donnee recu avec success'});
});
let lastdata = { name: '', number: '' };
app.get('/last',(req, res) => {
    res.json(lastdata); // <-- renvoie les donne enregistre
})

app.listen(3000, ()=> {
    console.log('Serveur demarrer sur le port 3000')
});