// Generated by CoffeeScript 1.10.0
"use strict";
var ganglere,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ganglere = require('../ganglere');

ganglere.Intro = (function(superClass) {
  extend(Intro, superClass);

  function Intro() {
    return Intro.__super__.constructor.apply(this, arguments);
  }

  Intro.prototype.preload = function() {};

  Intro.prototype.create = function() {
    this.add.sprite(0, 0, 'splash');
    this.add.button(100, 270, 'playButton', this.startGame, this, 2, 1, 0);
    this.add.button(100, 310, 'creditsButton', this.showCredits, this, 2, 1, 0);
    return this.add.button(100, 350, 'scoreButton', this.showScores, this, 2, 1, 0);
  };

  Intro.prototype.showCredits = function() {
    return this.state.start('Credits', true, false);
  };

  Intro.prototype.showScores = function() {
    return this.state.start('Scores', true, false);
  };

  Intro.prototype.startGame = function() {
    return this.state.start('Levels', true, false, {
      level: 0
    });
  };

  return Intro;

})(Phaser.State);
