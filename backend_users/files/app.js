const fs = require('fs')

fs.readFile('example.txt','utf8', (err , data) => {
    if (err) {
        console.error('error: ', err);
        return;
    }
    console.log('message is: ', data);
});

