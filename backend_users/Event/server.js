const WebSocket = require('ws');
const server = new WebSocket.Server({ port: 8080 });

console.log('Serveur WebSocket lancé sur ws://localhost:8080');

server.on('connection', (ws) => {
  console.log('Client connecté');

  ws.on('message', (msg) => {
    const data = JSON.parse(msg);

    if (data.type === 'broadcast') {
      server.clients.forEach((client) => {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
          client.send(`${data.name} a dit : ${data.message}`);
        }
      });

      ws.send(`Tu as dit : ${data.message}`);
    }
  });

  ws.on('close', () => {
    console.log('Client déconnecté');
  });

  ws.on('error', (err) => {
    console.error('Erreur WebSocket :', err.message);
  });
});
