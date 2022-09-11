'use strict';
const jwt = require('jsonwebtoken');
const fs = require('fs');
const socketServer = require('socket.io')();
const User = require('../schemas/user');
const { remove } = require('lodash');

const usersOnline = {};

socketServer
  .use(async (socket, next) => {
    try {
      const decoded = jwt.verify(socket.handshake.query.token, fs.readFileSync('./public.key', 'utf8'));
      const user = await User.findOne({ username: decoded.username });
      socket.request.user = user;
      next();
    } catch (err) {
      next(new Error('Authentication error'));
    }
  })
  .on('connection', async (socket) => {
    usersOnline[socket.request.user._id] = socket;

    socket.on('disconnect', () => {
      delete usersOnline[socket.request.user._id];
    });

    socket.on('SEND_MESSAGE', (data) => {
      let targetId = msg.targetId;
      if (usersOnline[targetId]) clients[targetId].emit('message', msg);
    });
  });

module.exports = { socketServer };
