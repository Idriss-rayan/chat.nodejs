const express = require('express')
const fs = require('fs/promises');
const cors = require('cors');


const app = express();
app.use(express.json());

