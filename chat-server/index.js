'use strict';
const express = require('express');
const { socketServer } = require('./routes/ws');

const app = express();

require('mongoose').connect(
  'mongodb://test:test@173.82.86.87:27017/test',
  { useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex: true },
  (err) => {
    if (err) throw Error(err);
    console.log('Mongoose connected');
  }
);

app.use(require('morgan')('dev'));
app.use(express.json());

app.use(require('cors')());

app.use('/auth', require('./routes/auth'));
app.use('/message', require('./routes/message'));

const server = require('http').Server(app);
socketServer.attach(server);
server.listen(3000, () => console.log('Server start on http://localhost:3000'));
