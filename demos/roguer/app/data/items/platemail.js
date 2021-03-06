// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

if (Game.ItemRepository == null) {
  Game.ItemRepository = new Game.Repository("items", Game.Item);
}

Game.ItemRepository.define("platemail", {
  name: "platemail",
  character: "[",
  foreground: "aliceblue",
  defenseValue: 6,
  wearable: true,
  mixins: [Game.ItemMixins.Equippable]
}, {
  disableRandomCreation: true
});
