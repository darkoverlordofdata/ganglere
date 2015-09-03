// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

if (Game.Screen == null) {
  Game.Screen = {};
}

Game.Screen.dropScreen = new Game.Screen.ItemListScreen({
  caption: "Choose the item you wish to drop",
  canSelect: true,
  canSelectMultipleItems: false,
  ok: function(selectedItems) {
    this._player.dropItem(Object.keys(selectedItems)[0]);
    return true;
  }
});
