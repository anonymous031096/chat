const jwt = require('jsonwebtoken');
const fs = require('fs');
const User = require('../schemas/user');

const checkAuth = (req, res, next) => {
  if (!req.headers.authorization) return res.status(400).json({ message: 'Thiếu Authorization headers' });
  const token = req.headers.authorization.split(' ')[1];
  if (!token) return res.status(400).json({ message: 'Invalid token' });

  jwt.verify(token, fs.readFileSync('./public.key', 'utf8'), (err, decoded) => {
    if (err) return res.status(401).json({ error: err });
    User.findOne({ username: decoded.username }, (err, user) => {
      if (err) return res.status(500).json({ error: err });
      if (!user) return res.status(401).json({ message: decoded.username + ' không tồn tại.' });
      req.user = user;
      next();
    });
  });
};

module.exports = { checkAuth };
