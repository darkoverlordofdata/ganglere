// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

if (Game.ItemRepository == null) {
  Game.ItemRepository = new Game.Repository("items", Game.Item);
}

Game.ItemRepository.define("melon", {
  name: "melon",
  character: "%",
  foreground: "lightGreen",
  foodValue: 35,
  consumptions: 4,
  mixins: [Game.ItemMixins.Edible]
});
