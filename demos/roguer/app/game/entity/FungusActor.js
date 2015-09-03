// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

Game.EntityMixins.FungusActor = {
  name: "FungusActor",
  groupName: "Actor",
  init: function() {
    return this._growthsRemaining = 5;
  },
  act: function() {
    var entity, xOffset, yOffset;
    if (this._growthsRemaining > 0) {
      if (Math.random() <= 0.02) {
        xOffset = Math.floor(Math.random() * 3) - 1;
        yOffset = Math.floor(Math.random() * 3) - 1;
        if (xOffset !== 0 || yOffset !== 0) {
          if (this.getMap().isEmptyFloor(this.getX() + xOffset, this.getY() + yOffset, this.getZ())) {
            entity = Game.EntityRepository.create("fungus");
            entity.setPosition(this.getX() + xOffset, this.getY() + yOffset, this.getZ());
            this.getMap().addEntity(entity);
            this._growthsRemaining--;
            return Game.sendMessageNearby(this.getMap(), entity.getX(), entity.getY(), entity.getZ(), "The fungus is spreading!");
          }
        }
      }
    }
  }
};
