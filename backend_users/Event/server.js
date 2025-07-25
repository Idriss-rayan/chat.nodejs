const WebSocket = require('ws');
const server = new WebSocket.Server({ port: 8080 });

console.log('server en attente sur ws://localhost:8080');

server.on('connection', (ws) => {
  console.log('client connecte');

  ws.on('message',(msg) => {
    const data = JSON.parse(msg);

    if (data.type === 'broadcast') {
      server.clients.forEach((client) =>{
        if (client !== ws && client.readyState === WebSocket.OPEN) {
          client.send(`${data.name} a dit : ${data.message}`);
        }
      });
      ws.send(`Tu as dit : ${data.message}`);
    }
  });
});