// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

Game.ItemMixins.Equippable = {
  name: "Equippable",
  init: function(template) {
    this._attackValue = template["attackValue"] || 0;
    this._defenseValue = template["defenseValue"] || 0;
    this._wieldable = template["wieldable"] || false;
    return this._wearable = template["wearable"] || false;
  },
  getAttackValue: function() {
    return this._attackValue;
  },
  getDefenseValue: function() {
    return this._defenseValue;
  },
  isWieldable: function() {
    return this._wieldable;
  },
  isWearable: function() {
    return this._wearable;
  },
  listeners: {
    details: function() {
      var results;
      results = [];
      if (this._wieldable) {
        results.push({
          key: "attack",
          value: this.getAttackValue()
        });
      }
      if (this._wearable) {
        results.push({
          key: "defense",
          value: this.getDefenseValue()
        });
      }
      return results;
    }
  }
};
