const express = require('express');

const websocket = require('ws');
const server = new websocket.server({ port: 8080 });

server.on('connection' , (ws) => {
    console.log('client connecte');

    ws.send('bienvenue');

    ws.on('message', (message) => {
        console.log('Message recu :', message);
        ws.send(`recu : ${message}`);
    });
});