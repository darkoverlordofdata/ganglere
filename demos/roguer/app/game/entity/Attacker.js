// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

Game.EntityMixins.Attacker = {
  name: "Attacker",
  groupName: "Attacker",
  init: function(template) {
    return this._attackValue = template["attackValue"] || 1;
  },
  getAttackValue: function() {
    var modifier;
    modifier = 0;
    if (this.hasMixin(Game.EntityMixins.Equipper)) {
      if (this.getWeapon()) {
        modifier += this.getWeapon().getAttackValue();
      }
      if (this.getArmor()) {
        modifier += this.getArmor().getAttackValue();
      }
    }
    return this._attackValue + modifier;
  },
  increaseAttackValue: function(value) {
    value = value || 2;
    this._attackValue += value;
    return Game.sendMessage(this, "You look stronger!");
  },
  attack: function(target) {
    var attack, damage, defense, max;
    if (target.hasMixin("Destructible")) {
      attack = this.getAttackValue();
      defense = target.getDefenseValue();
      max = Math.max(0, attack - defense);
      damage = 1 + Math.floor(Math.random() * max);
      Game.sendMessage(this, "You strike the %s for %d damage!", [target.getName(), damage]);
      Game.sendMessage(target, "The %s strikes you for %d damage!", [this.getName(), damage]);
      return target.takeDamage(this, damage);
    }
  },
  listeners: {
    details: function() {
      return [
        {
          key: "attack",
          value: this.getAttackValue()
        }
      ];
    }
  }
};
