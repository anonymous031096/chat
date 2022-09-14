const router = require('express').Router();
const Message = require('../schemas/message');
const { checkAuth } = require('../utils/auth.service');

router.get('/:senderId/:receiverId', checkAuth, async (req, res) => {
  const { senderId, receiverId } = req.params;

  console.log(senderId);

  //   try {
  const messages = await Message.find({
    $or: [
      { sender: senderId, receiver: receiverId },
      { sender: receiverId, receiver: senderId },
    ],
  });

  return res.status(200).json(messages);
  //   } catch (err) {
  //     return res.status(500).json(err);
  //   }
});

module.exports = router;
