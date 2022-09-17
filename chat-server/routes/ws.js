'use strict';
const jwt = require('jsonwebtoken');
const fs = require('fs');
const socketServer = require('socket.io', {
  cors: {
    origins: '*:*',
    methods: ['GET', 'POST'],

    credentials: true,
  },
})();
const User = require('../schemas/user');
const { remove } = require('lodash');
const Message = require('../schemas/message');

const usersOnline = {};

socketServer.on('connection', async (socket) => {
  socket.on('signin', (id) => {
    console.log(id);
    usersOnline[id] = socket;
  });

  setTimeout(() => {
    socket.emit('noti', 'true');
  }, 10000);

  socket.on('USERS', (id) => {
    User.find().then((user) => {
      socket.emit('USERS', user);
    });
  });

  // socket.on('disconnect', () => {
  //   delete usersOnline[];
  // });

  socket.on('SEND_MESSAGE', async (data) => {
    const { senderId, receiverId, message } = data;
    if (!senderId || !receiverId || !message) return;
    await Message.create({ sender: senderId, receiver: receiverId, message });
    if (usersOnline[receiverId]) usersOnline[receiverId].emit('RECEIVE_MESSAGE', data);
  });
});

module.exports = { socketServer };
