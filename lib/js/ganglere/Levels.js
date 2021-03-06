// Generated by CoffeeScript 1.10.0
"use strict";
var ganglere,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ganglere = require("../ganglere");

ganglere.Levels = (function(superClass) {
  var BLACK, HUNTER, WHITE;

  extend(Levels, superClass);

  function Levels() {
    this.showDamage = bind(this.showDamage, this);
    this.initActors = bind(this.initActors, this);
    this.fadeOut = bind(this.fadeOut, this);
    this.label = bind(this.label, this);
    this.startGame = bind(this.startGame, this);
    this.moveTo = bind(this.moveTo, this);
    this.doKeyUp = bind(this.doKeyUp, this);
    this.onKeyUp = bind(this.onKeyUp, this);
    this.moveCallback = bind(this.moveCallback, this);
    this.create = bind(this.create, this);
    this.init = bind(this.init, this);
    return Levels.__super__.constructor.apply(this, arguments);
  }

  WHITE = '#fff';

  BLACK = '#000';

  HUNTER = '#ff0044';

  Levels.prototype.automove = true;

  Levels.prototype.inmotion = false;

  Levels.prototype.actorList = null;

  Levels.prototype.actorMap = null;

  Levels.prototype.player = null;

  Levels.prototype.options = null;

  Levels.prototype.hud = null;

  Levels.prototype.map = null;

  Levels.prototype.clickeable = true;

  Levels.prototype.score = 0;

  Levels.prototype.level = 0;

  Levels.prototype.name = 'Splash';

  Levels.prototype.levels = ['Fenris', 'Loke', 'Thor', 'Game Over'];

  Levels.prototype.init = function(options) {
    var key, value;
    for (key in options) {
      value = options[key];
      this[key] = value;
    }
    return this.name = this.levels[this.level];
  };

  Levels.prototype.create = function() {
    var hudStyle, key, ref, value;
    this.time.advancedTiming = true;
    hudStyle = {
      font: "bold 18px monospace",
      fill: BLACK
    };
    ref = ganglere.config.levels[this.name];
    for (key in ref) {
      value = ref[key];
      console.log(key);
      console.log(value);
      this[key] = value;
    }
    this.map = new ganglere.Map(this);
    this.stage.backgroundColor = "#F0DE9C";
    this.initActors();
    this.map.light();
    this.hud = this.add.text(0, 0, this.label(this.actorList[0].hp, this.score, this.level), hudStyle);
    this.hud.fixedToCamera = true;
    this.hud.cameraOffset.setTo(0, this.game.height - 35);
    this.input.keyboard.addCallbacks(null, null, this.onKeyUp);
    this.input.onDown.add(this.onKeyUp, this);
    this.input.setMoveCallback(this.moveCallback, this);
  };

  Levels.prototype.moveCallback = function() {
    var dx, dy, x, y;
    if (this.clickeable && this.input.activePointer.isDown) {
      this.clickeable = false;
      setTimeout(((function(_this) {
        return function() {
          return _this.clickeable = true;
        };
      })(this)), 400);
      x = this.input.activePointer.worldX;
      y = this.input.activePointer.worldY;
      dx = Math.abs(this.player.sprite.x - x);
      dy = Math.abs(this.player.sprite.y - y);
      if (dx > dy) {
        if (x > this.player.sprite.x) {
          this.onKeyUp({
            keyCode: Phaser.Keyboard.RIGHT
          });
        } else {
          this.onKeyUp({
            keyCode: Phaser.Keyboard.LEFT
          });
        }
      } else {
        if (y > this.player.sprite.y) {
          this.onKeyUp({
            keyCode: Phaser.Keyboard.DOWN
          });
        } else {
          this.onKeyUp({
            keyCode: Phaser.Keyboard.UP
          });
        }
      }
    }
  };

  Levels.prototype.onKeyUp = function(event) {
    var actor, i, len, ref;
    if (!this.actorList[0].isPlayer) {
      return;
    }
    if (this.doKeyUp(event)) {
      this.map.computeLight();
      ref = this.actorList;
      for (i = 0, len = ref.length; i < len; i++) {
        actor = ref[i];
        actor.move(this.player);
        if (this.player.hp < 1) {
          this.fadeOut((function(_this) {
            return function() {
              return _this.state.start('Levels', false, false, {
                level: _this.levels.length,
                win: false
              });
            };
          })(this));
          break;
        }
      }
    }
  };

  Levels.prototype.doKeyUp = function(event) {
    switch (event.keyCode) {
      case Phaser.Keyboard.LEFT:
        return this.moveTo(this.player, {
          x: -1,
          y: 0
        });
      case Phaser.Keyboard.RIGHT:
        return this.moveTo(this.player, {
          x: 1,
          y: 0
        });
      case Phaser.Keyboard.UP:
        return this.moveTo(this.player, {
          x: 0,
          y: -1
        });
      case Phaser.Keyboard.DOWN:
        return this.moveTo(this.player, {
          x: 0,
          y: 1
        });
      default:
        return false;
    }
  };

  Levels.prototype.moveTo = function(actor, delta) {
    var pos, victim;
    if (!this.map.isValidMove(actor, delta)) {
      return false;
    }
    actor.setFrame(delta);
    pos = (actor.x + delta.x) + "_" + (actor.y + delta.y);
    if (this.actorMap[pos] != null) {
      victim = this.actorMap[pos];
      if (actor.isPlayer || victim.isPlayer) {
        actor.attack(victim);
        if (victim.isPlayer) {
          this.hud.setText(this.label(victim.hp, this.score, this.level));
        } else {
          this.score += ganglere.Random.diceRoll("d2+1").total;
          this.hud.setText(this.label(this.actorList[0].hp, this.score, this.level));
        }
        if (victim.hp <= 0) {
          victim.sprite.kill();
          delete this.actorMap[pos];
          this.actorList.splice(this.actorList.indexOf(victim), 1);
          if (victim !== this.player) {
            if (this.actorList.length === 1) {
              this.level++;
              if (this.level < this.levels.length) {
                this.fadeOut((function(_this) {
                  return function() {
                    return _this.state.start('Levels', true, false, {
                      level: _this.level
                    });
                  };
                })(this));
              } else {
                this.fadeOut((function(_this) {
                  return function() {
                    return _this.state.start('Levels', false, false, {
                      level: _this.levels.length,
                      win: true
                    });
                  };
                })(this));
              }
            }
          }
        }
      }
    } else {
      delete this.actorMap[actor.x + "_" + actor.y];
      actor.setXY(actor.x + delta.x, actor.y + delta.y);
      this.actorMap[actor.x + "_" + actor.y] = actor;
    }
    return true;
  };

  Levels.prototype.startGame = function() {
    var startGame;
    startGame = (function(_this) {
      return function() {
        return _this.state.start('Levels', true, false, {
          level: 1
        });
      };
    })(this);
    this.time.events.add(Phaser.Timer.SECOND, startGame, this);
    return this.add.tween(this.start).to({
      alpha: 0
    }, 2000, Phaser.Easing.Linear.None, true);
  };

  Levels.prototype.label = function(hp, score, level) {
    return "life:  " + hp + " score: " + score + " level: " + level;
  };

  Levels.prototype.fadeOut = function(next) {
    return this.time.events.add(Phaser.Timer.SECOND, next, this);
  };

  Levels.prototype.initActors = function() {
    var a, actor, i, j, k, random, ref, ref1, ref2, ref3, validpos, x, y;
    this.actorList = [];
    this.actorMap = {};
    random = function(max) {
      return Math.floor(Math.random() * max);
    };
    validpos = [];
    for (x = i = 0, ref = this.map.width; 0 <= ref ? i < ref : i > ref; x = 0 <= ref ? ++i : --i) {
      for (y = j = 0, ref1 = this.map.height; 0 <= ref1 ? j < ref1 : j > ref1; y = 0 <= ref1 ? ++j : --j) {
        if (!this.map.tiles[x][y]) {
          validpos.push({
            x: x,
            y: y
          });
        }
      }
    }
    for (a = k = 0, ref2 = this.options.actors; 0 <= ref2 ? k < ref2 : k > ref2; a = 0 <= ref2 ? ++k : --k) {
      while (true) {
        ref3 = validpos[random(validpos.length)], x = ref3.x, y = ref3.y;
        if (!this.actorMap[x + "_" + y]) {
          break;
        }
      }
      actor = a === 0 ? new ganglere.Player(this, x, y) : new ganglere.Enemy(this, x, y);
      this.actorMap[actor.x + "_" + actor.y] = actor;
      this.actorList.push(actor);
    }
    this.player = this.actorList[0];
    this.camera.follow(this.player.sprite);
  };

  Levels.prototype.showDamage = function(text, sprite, speed, color) {
    var damageStyle, x, y;
    if (navigator.notification != null) {
      navigator.notification.vibrate(10);
    }
    damageStyle = {
      align: 'center',
      font: 'bold 40px Courier New, Courier',
      fill: color
    };
    y = sprite.y - 15;
    x = sprite.x + sprite.width / 3;
    text = this.add.text(x, y, text, damageStyle);
    this.add.tween(text).to({
      alpha: 1
    }, Math.floor(speed * 0.75), Phaser.Easing.Bounce.Out, true).to({
      alpha: 0
    }, Math.floor(speed * 0.25), Phaser.Easing.Bounce.In, true);
    return setTimeout(((function(_this) {
      return function() {
        return _this.world.remove(text);
      };
    })(this)), speed);
  };

  return Levels;

})(Phaser.State);
