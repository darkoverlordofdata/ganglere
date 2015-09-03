// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

if (Game.ItemRepository == null) {
  Game.ItemRepository = new Game.Repository("items", Game.Item);
}

Game.ItemRepository.define("staff", {
  name: "staff",
  character: ")",
  foreground: "yellow",
  attackValue: 5,
  defenseValue: 3,
  wieldable: true,
  mixins: [Game.ItemMixins.Equippable]
}, {
  disableRandomCreation: true
});
