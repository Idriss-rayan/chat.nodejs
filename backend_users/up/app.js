const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;

app.use(express.json());

// 📁 Vérifier que le dossier 'uploads' existe, sinon le créer
const uploadDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir);
}

// ⚙️ Configuration de multer
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads'); // Dossier de destination
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname); // Nom unique du fichier
    }
});

const upload = multer({ storage });

// 📤 Route pour uploader un fichier 
app.post('/upload', upload.single('fichier'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ error: 'Aucun fichier envoyé' });
    }

    res.json({
        message: 'Fichier uploadé avec succès',
        nomFichier: req.file.filename,
        chemin: req.file.path,
        taille: req.file.size + ' octets'
    });
});

// 📥 Route pour télécharger un fichier
app.get('/download/:filename', (req, res) => {
    const filename = req.params.filename;
    const filePath = path.join(__dirname, 'uploads', filename);

    // Vérifier que le fichier existe
    fs.access(filePath, fs.constants.F_OK, (err) => {
        if (err) {
            return res.status(404).json({ error: 'Fichier introuvable' });
        }

        res.download(filePath, (err) => {
            if (err) {
                console.error('Erreur lors du téléchargement :', err);
                res.status(500).json({ error: 'Erreur serveur pendant le téléchargement' });
            }
        });
    });
});

app.get('/files', (req, res) =>{
    const uploadsDir = path.join(__dirname, 'uploads');

    fs.readdir(uploadDir, (err, files) => {
        if (err) return res.status(500).json({error: 'erreur de lecture du dossier'});

    res.json({
        total: files.lenght,
        fichiers: files
    });
  });
});

app.delete('/delete/:filename', (req, res) => {
    const filename = req.params.filename;
    const filePath = path.join(__dirname, 'uploads', filename);

    fs.unlink(filePath, (err) => {
        if(err) return res.status(500).json({ error: 'erreure de suppression de fichiers ou fichier introuvable'});
    });

    res.json({message: `Fichier '${filename}' supprimer.`});
});

// 🚀 Lancer le serveur
app.listen(PORT, () => {
    console.log(`Serveur sur http://localhost:${PORT}`);
});
