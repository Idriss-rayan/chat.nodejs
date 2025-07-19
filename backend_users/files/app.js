const path = require('path');
const fs = require ('fs');

const chemin = path.join(__dirname , 'docs' , 'document.txt');
console.log(chemin);

fs.readFile(chemin , 'utf8', (err , data)=>{
    if (err) throw err;
    console.log('le text est: ', data);
});

console.log('le nom :', path.basename(chemin));
console.log('le parent :', path.dirname(chemin));
console.log('le extension :', path.extname(chemin));