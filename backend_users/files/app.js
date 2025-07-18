const fs = require('fs');

fs.readFile('example.txt' , 'utf8' , (err , data) => {
    if (err) {
        console.error('Error of read : ', err);
        return;
    }
    console.log('content of file is :', data);
});

