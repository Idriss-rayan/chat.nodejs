const WebSocket = require('ws');
const server = new WebSocket.Server({ port: 8080 });

console.log('Server en ecoute sur ws://localhost:8080');

const clients = new Map();

server.on('connection', (ws) => {
  console.log('nouveau client connecte');

  let authenticated = false;

  ws.on('message', (msg) => {
    const data = JSON.parse(msg);

    if (!authenticated && data.type === 'auth') {
      clients.set(ws, data.username);
      authenticated = true;
      ws.send(`Bonjour ${data.username}, tu es maintenant authentifié.`);
      return;
    }

    if (authenticated && data.type === 'message') {
      const name = clients.get(ws);
      const content = `${name} dit : ${data.message}`;

      server.clients.forEach((client) => {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
          client.send(content);
        }
      });

      ws.send(`Tu as dit : ${data.message}`);
    }
  });

  ws.on('close', () => {
    const name = clients.get(ws);
    console.log(`${name || 'un client'} s'est deconnecté`);
    clients.delete(ws);
  });
});
