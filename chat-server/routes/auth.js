const router = require('express').Router();
const User = require('../schemas/user');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const fs = require('fs');

router.post('/signup', async (req, res) => {
  const { username, password, name } = req.body;

  try {
    const user = await User.findOne({ username });
    if (user) return res.status(409).json({ message: `${username} already exist.` });

    const hash = await bcrypt.hash(password, 1);
    await User.create({ username, password: hash, name });

    return res.sendStatus(200);
  } catch (err) {
    return res.status(500).json(err);
  }
});

router.post('/signin', async (req, res) => {
  const { username, password } = req.body;

  try {
    const user = await User.findOne({ username });
    if (!user) return res.status(404).json({ message: `${username} does't exist.` });

    const same = await bcrypt.compare(password, user.password);
    if (!same) return res.status(400).json({ message: `Incorrect password.` });

    const accessToken = jwt.sign({ username, id: user._id, name: user.name }, fs.readFileSync('./private.key', 'utf8'), {
      expiresIn: '1d',
      algorithm: 'RS256',
    });

    return res.json({ accessToken });
  } catch (err) {
    return res.status(500).json(err);
  }
});

module.exports = router;
