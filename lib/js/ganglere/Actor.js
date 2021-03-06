// Generated by CoffeeScript 1.10.0
"use strict";
var ganglere,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ganglere = require('../ganglere');

ganglere.Actor = (function() {
  var FRAME_BACK, FRAME_FRONT, FRAME_LEFT, FRAME_RIGHT, HUNTER, WHITE, ref;

  Actor.all = [];

  Actor.map = {};

  ref = ganglere.config, FRAME_FRONT = ref.FRAME_FRONT, FRAME_BACK = ref.FRAME_BACK, FRAME_LEFT = ref.FRAME_LEFT, FRAME_RIGHT = ref.FRAME_RIGHT;

  WHITE = '#fff';

  HUNTER = '#ff0044';

  Actor.prototype.isPlayer = false;

  Actor.prototype.game = null;

  Actor.prototype.sprite = null;

  Actor.prototype.x = 0;

  Actor.prototype.y = 0;

  Actor.prototype.hp = 0;

  Actor.prototype.damage = "d8+2";

  function Actor(game, x, y, key) {
    this.setFrame = bind(this.setFrame, this);
    this.setOfset = bind(this.setOfset, this);
    this.setXY = bind(this.setXY, this);
    this.attack = bind(this.attack, this);
    this.move = bind(this.move, this);
    this.hp = 3;
    this.x = x;
    this.y = y;
    this.config = ganglere.config.sprites[key];
    this.setOfset(this.config.axis);
    this.key = this.config.selected != null ? key + "[" + this.config.selected + "]" : key;
    if (game) {
      this.game = game;
      this.sprite = game.add.sprite(x * 32, y * 32, this.key);
    }
  }

  Actor.prototype.move = function() {};

  Actor.prototype.attack = function(victim) {
    var axis, color, damage, dir, pos1, pos2;
    damage = ganglere.Random.diceRoll(this.damage).total;
    victim.hp -= damage;
    axis = this.x === victim.x ? "y" : "x";
    dir = victim[axis] - this[axis];
    dir = dir / Math.abs(dir);
    pos1 = {};
    pos2 = {};
    pos1[axis] = (dir * 15).toString();
    pos2[axis] = (dir * 15 * (-1)).toString();
    this.game.camera.follow(false);
    this.game.add.tween(this.sprite).to(pos1, 200, Phaser.Easing.Elastic.In, true).to(pos2, 200, Phaser.Easing.Elastic.Out, true).onComplete.add(((function(_this) {
      return function() {
        return _this.game.camera.follow(_this.sprite);
      };
    })(this)), this);
    color = victim.isPlayer ? HUNTER : WHITE;
    return this.game.showDamage(damage.toString(), victim.sprite, 450, color);
  };

  Actor.prototype.setXY = function(x, y) {
    this.x = x;
    this.y = y;
    this.game.add.tween(this.sprite).to({
      x: x * 32,
      y: y * 32
    }, 500, Phaser.Easing.Linear.None, true);
  };

  Actor.prototype.setOfset = function(axis) {
    var r0, r1, r2, r3;
    switch (this.config.type) {
      case 0:
        r0 = axis * 4 + this.config.order[0];
        r1 = axis * 4 + this.config.order[1];
        r2 = axis * 4 + this.config.order[2];
        r3 = axis * 4 + this.config.order[3];
        break;
      case 1:
        r0 = axis + this.config.cols * this.config.order[0];
        r1 = axis + this.config.cols * this.config.order[1];
        r2 = axis + this.config.cols * this.config.order[2];
        r3 = axis + this.config.cols * this.config.order[3];
        break;
      default:
        r0 = 0;
        r1 = 0;
        r2 = 0;
        r3 = 0;
    }
    return this.ofset = [r0, r1, r2, r3];
  };

  Actor.prototype.setFrame = function(dir) {
    if (dir.x === 1) {
      return this.sprite.frame = this.ofset[FRAME_RIGHT];
    } else if (dir.x === -1) {
      return this.sprite.frame = this.ofset[FRAME_LEFT];
    } else if (dir.y === -1) {
      return this.sprite.frame = this.ofset[FRAME_BACK];
    } else if (dir.y === 1) {
      return this.sprite.frame = this.ofset[FRAME_FRONT];
    }
  };

  return Actor;

})();
