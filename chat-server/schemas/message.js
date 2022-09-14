const mongoose = require('mongoose');
const user = require('./user');
const Schema = mongoose.Schema;

const messageSchema = mongoose.Schema(
  {
    sender: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    receiver: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    message: { type: Schema.Types.String, required: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Message', messageSchema);
