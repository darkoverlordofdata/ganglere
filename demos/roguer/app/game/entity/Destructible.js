// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

Game.EntityMixins.Destructible = {
  name: "Destructible",
  init: function(template) {
    this._maxHp = template["maxHp"] || 10;
    this._hp = template["hp"] || this._maxHp;
    return this._defenseValue = template["defenseValue"] || 0;
  },
  getDefenseValue: function() {
    var modifier;
    modifier = 0;
    if (this.hasMixin(Game.EntityMixins.Equipper)) {
      if (this.getWeapon()) {
        modifier += this.getWeapon().getDefenseValue();
      }
      if (this.getArmor()) {
        modifier += this.getArmor().getDefenseValue();
      }
    }
    return this._defenseValue + modifier;
  },
  getHp: function() {
    return this._hp;
  },
  getMaxHp: function() {
    return this._maxHp;
  },
  setHp: function(hp) {
    return this._hp = hp;
  },
  increaseDefenseValue: function(value) {
    value = value || 2;
    this._defenseValue += value;
    return Game.sendMessage(this, "You look tougher!");
  },
  increaseMaxHp: function(value) {
    value = value || 10;
    this._maxHp += value;
    this._hp += value;
    return Game.sendMessage(this, "You look healthier!");
  },
  takeDamage: function(attacker, damage) {
    this._hp -= damage;
    if (this._hp <= 0) {
      Game.sendMessage(attacker, "You kill the %s!", [this.getName()]);
      this.raiseEvent("onDeath", attacker);
      attacker.raiseEvent("onKill", this);
      return this.kill();
    }
  },
  listeners: {
    onGainLevel: function() {
      return this.setHp(this.getMaxHp());
    },
    details: function() {
      return [
        {
          key: "defense",
          value: this.getDefenseValue()
        }, {
          key: "hp",
          value: this.getHp()
        }
      ];
    }
  }
};
