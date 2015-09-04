// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

if (Game.Screen == null) {
  Game.Screen = {};
}

Game.Screen.eatScreen = new Game.Screen.ItemListScreen({
  caption: "Choose the item you wish to eat",
  canSelect: true,
  canSelectMultipleItems: false,
  isAcceptable: function(item) {
    return item && item.hasMixin("Edible");
  },
  ok: function(selectedItems) {
    var item, key;
    key = Object.keys(selectedItems)[0];
    item = selectedItems[key];
    Game.sendMessage(this._player, "You eat %s.", [item.describeThe()]);
    item.eat(this._player);
    if (!item.hasRemainingConsumptions()) {
      this._player.removeItem(key);
    }
    return true;
  }
});