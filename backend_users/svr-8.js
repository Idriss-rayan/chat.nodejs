const WebSocket = require('ws');
const server = new WebSocket.Server({ port: 8080 });

console.log('Serveur WebSocket lancé sur ws://localhost:8080');

const clients = new Map(); // ws => { username, room }

server.on('connection', (ws) => {
  console.log('Client connecté');

  ws.on('message', (msg) => {
    const data = JSON.parse(msg);

    // Authentification
    if (data.type === 'auth') {
      clients.set(ws, { username: data.username, room: null });
      ws.send(`Bonjour ${data.username}, tu es connecté.`);
      return;
    }

    // Rejoindre un salon
    if (data.type === 'joinRoom') {
      const client = clients.get(ws);
      if (client) {
        client.room = data.room;
        ws.send(`Tu as rejoint le salon : ${data.room}`);
      }
      return;
    }

    //Message dans une room
    if (data.type === 'message') {
      const sender = clients.get(ws);
      if (!sender || !sender.room) {
        ws.send("Tu dois d'abord rejoindre un salon.");
        return;
      }

      const text = `${sender.username} : ${data.message}`;

      // Envoie le message uniquement aux clients dans la même room
      clients.forEach((clientInfo, clientWs) => {
        if (
          clientWs.readyState === WebSocket.OPEN &&
          clientInfo.room === sender.room
        ) {
          clientWs.send(text);
        }
      });
    }
  });

  ws.on('close', () => {
    const user = clients.get(ws);
    console.log(`${user?.username || 'Un client'} déconnecté.`);
    clients.delete(ws);
  });
});
