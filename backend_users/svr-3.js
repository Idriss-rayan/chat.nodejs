const express = require('express')
const cors = require('cors')
const bodyparser = require('body-parser')

const app = express();
app.use(cors());
app.use(bodyparser.json());

let contact = [];

app.post ('/', (req,res) =>{
    contact.push(req.body);
});

app.get ('/', (req,res) =>{
    res.json(contact)
})

app.listen(3000,()=>{
    console.log('listen on port 3000')
})