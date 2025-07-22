const WebSocket = require('ws');

const server = new WebSocket.Server({ port: 8080 });

console.log('Serveur WebSocket en attente sur ws://localhost:8080');

server.on('connection', (ws) => {
  console.log('Nouveau client connecté');

  const now = new Date();
  const hour = now.getHours();

  const greeting = hour < 18 ? 'Bonjour' : 'Bonsoir';
  ws.send(`${greeting}, bienvenue sur le serveur WebSocket`);

  ws.on('message', (message) => {
    console.log('Message reçu :', message.toString());
    ws.send(`Reçu : ${message}`);
  });

  ws.on('close', () => {
    console.log('Client déconnecté');
  });
});
