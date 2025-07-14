const express = require('express')
const cors = require('cors')
const bodyparser = require('body-parser')

app = express();
app.use(cors());
app.use(bodyparser.json());

let contact = [];

app.post('/users', (req,res)=>{
    const {id , name , email} = req.body;
    contact.push({id,name,email});
})

app.get('/users',(req,res)=>{
    res.json(contact);
})

app.listen(3000, ()=>{
    console.log('listen on port 3000 ...');
})