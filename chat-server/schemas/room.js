const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const roomSchema = mongoose.Schema(
  {
    game: { type: String, required: true },
    password: { type: String },
    banker: { type: Schema.Types.ObjectId, ref: 'User' },
    players: [{ type: Schema.Types.ObjectId, ref: 'User' }],
    maxPlayer: { type: Number, required: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Room', roomSchema);
