const Board = (() => {
  let instance;

  function Singleton() {
    this.rooms = [];

    this.playerHasRoom = (userId) => {
      if (!this.rooms.length) return false;
      const room = this.rooms.find((r) => {
        if (r.banker.userId === userId) return true;
        if (!r.players.length) return false;
        const player = r.players.find((p) => p.userId === userId);
        if (player) return true;
        return false;
      });
      if (room) return true;
    };
  }

  return {
    getInstance: () => {
      if (!instance) {
        instance = new Singleton();
      }
      return instance;
    },
  };
})();

module.exports = Board;
