const express = require('express')
const bodyparser = require('body-parser')
const cors = require('cors')

const app = express();
app.use(cors());
app.use(bodyparser.json())

app.post('/',(req,res) => {
    const { name, email , message } = req.body;
    res.json({status: 'success', message: 'donnee recus'})
})

app.listen(3000, ()=> {
    console.log('Serveur demarrer sur le port 3000')
})