const express = require('express')
const bodyparser = require('body-parser')
const cors = require('cors')

const app = express();
app.use(cors());
app.use(bodyparser.json())

app.post('/',(req, res) => {
    const { name , email , message } = req.body;
    console.log('son nom est: ',name);
    console.log('son email est: ',email);
    console.log('le message envoyer est: ',message);
})

app.listen(3000, ()=> {
    console.log('Serveur demarrer sur le port 3000')
});