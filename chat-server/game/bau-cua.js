const User = require('../schemas/user');

const TIME_BET = 30;
const TIME_WAIT_OPEN = 5;
const TIME_WAIT_START = 10;

const STATE = {
  BET: 'BET',
  WAIT_OPEN: 'WAIT_OPEN',
  WAIT_START: 'WAIT_START',
};

module.exports = function BauCua(socketServer, playerConnecteds) {
  this.id = 'bau-cua';

  this.timeBet = TIME_BET;
  this.timeWaitOpen = TIME_WAIT_OPEN;
  this.timeWaitStart = TIME_WAIT_START;
  this.state = STATE.WAIT_START;
  this.result = [0, 0, 0];
  this.playerBets = {};

  setInterval(() => {
    switch (this.state) {
      case STATE.WAIT_START:
        if (this.timeWaitStart > 0) {
          socketServer.to(this.id).emit(STATE.WAIT_START, this.timeWaitStart--);
        } else {
          this.state = STATE.BET;
          this.timeWaitStart = TIME_WAIT_START;
        }
        break;
      case STATE.BET:
        if (this.timeBet > 0) {
          socketServer.to(this.id).emit(STATE.BET, this.timeBet--);
        } else {
          this.state = STATE.WAIT_OPEN;
          this.timeBet = TIME_BET;
        }
        break;
      case STATE.WAIT_OPEN:
        if (this.timeWaitOpen > 0) {
          socketServer.to(this.id).emit(STATE.WAIT_OPEN, this.timeWaitOpen--);
        } else {
          this.result = [this.random(), this.random(), this.random()];
          socketServer.to(this.id).emit('OPEN', this.result);
          this.state = STATE.WAIT_START;
          this.timeWaitOpen = TIME_WAIT_OPEN;
          this.calculateProfit();
        }
        break;
    }
  }, 1000);

  this.addPlayer = (socket) => {
    socket.join(this.id);

    socket.on('BET', async ({ target, volume }) => {
      if (this.state !== STATE.BET) {
        socket.emit('BET_FAIL', 'Hết thời gian đặt');
        return;
      }
      const bets = this.playerBets[String(socket.request.user._id)] || [0, 0, 0, 0, 0, 0];
      const user = await User.findOne({ _id: socket.request.user._id });
      let totalVolume = volume;
      bets.forEach((b, i) => {
        if (i !== target) totalVolume += b;
      });
      if (totalVolume > user.balance) {
        socket.emit('BET_FAIL', 'Bạn không đủ hoa');
        return;
      }

      bets[target] = volume;
      this.playerBets[String(socket.request.user._id)] = bets;
      socket.emit('BET_SUCCESS', bets);
    });
  };

  this.calculateProfit = async () => {
    for (const [key, value] of Object.entries(this.playerBets)) {
      let profit = 0;
      value.forEach((b, i) => {
        if (!this.result.includes(i)) profit -= b;
      });
      this.result.forEach((v) => (profit += value[v]));
      if (profit === 0) return;
      await this.setProfit(key, profit);
    }
    this.playerBets = {};
  };

  this.setProfit = async (userId, profit) => {
    const user = await User.findOne({ _id: userId });
    if (user) {
      await User.updateOne({ _id: userId }, { $set: { balance: user.balance + profit } });
      const socket = playerConnecteds.find((s) => String(s.request.user._id) === userId);
      if (socket) socket.emit('BALANCE_CHANGE', { balance: user.balance + profit, profit });
    }
  };

  this.random = () => {
    return Math.floor(Math.random() * 6);
  };
};
