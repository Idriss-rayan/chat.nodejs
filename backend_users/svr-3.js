const express = require('express')
const cors = require('cors')
const bodyparser = require('body-parser')

const app = express();
app.use(cors());
app.use(bodyparser.json());

let contact = [];

