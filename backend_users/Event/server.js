const fs = require('fs');
const WebSocket = require('ws');

const server = new WebSocket.Server({ port: 8080 });

server.on('connection', (ws) => {
  console.log('🟢 Client connecté au flux vidéo');

  const readStream = fs.createReadStream('video.mp4', {
    highWaterMark: 64 * 1024 // envoie des petits morceaux (64 KB)
  });

  readStream.on('data', (chunk) => {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(chunk); // envoie le morceau vidéo
    }
  });

  readStream.on('end', () => {
    console.log('✅ Vidéo terminée');
    ws.send('END_OF_STREAM');
  });

  readStream.on('error', (err) => {
    console.error('❌ Erreur de lecture :', err);
  });
});
