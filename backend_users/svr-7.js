const WebSocket = require('ws');
const server = new WebSocket.Server({port: 8080});

console.log('Serveur Websocket demarre sur ws://localhost: 8080');

const clients = new Map();

function broadcastUserList() {
    const users = [...clients.values()];
    const message = JSON.stringify({ type: 'userList', users });

    server.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(message);
        }
    });
}

server.on('connection', (ws) => {
    console.log('nouveau client connecte');

    let authenticated = false;

    ws.on('message', (msg) => {
        const data = JSON.parse(msg);

        if (!authenticated && data.type === 'auth') {
            const username = data.username;

            clients.set (ws, username);
            authenticated = true;

            console.log(`${username} est connecter`);
            ws.send(`Bonjour ${username}, tu es maintenant authentifier.`);

            broadcastUserList();
            return;
        }

        if (authenticated && data.type === 'message') {
            const sender = client.get(ws);
            const content = `${sender} a dit : ${data.message}`;

            server.clients.forEach(clients => {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(content);
                }
            });
        }
    });

    ws.on('close', () =>{
        const username = clients.get(ws) || 'Un utilisateur';
        console.log(`${username} s'est deconnecter`);
        clients.delete(ws);
        broadcastUserList(); // mettre a jour la liste
    });
});