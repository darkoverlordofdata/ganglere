// Generated by CoffeeScript 1.7.1
"use strict";
var ganglere,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ganglere = require('../ganglere');

ganglere.Credits = (function(_super) {
  __extends(Credits, _super);

  function Credits() {
    return Credits.__super__.constructor.apply(this, arguments);
  }

  Credits.prototype.text = "Program by darkoverlordofdata\n\nSprites by Svetlana Kushnariova\n  lana-chan@yandex.ru\n\nWeb font Eagle Lake by astigmatic\n\nVellum toned paper texture by sporkystock";

  Credits.prototype.copyright = "Copyright 2014 Dark Overlord of Data";

  Credits.prototype.quoteStyle = {
    font: "italic 14px Arial",
    fill: '#000',
    align: 'center'
  };

  Credits.prototype.style = {
    font: "14px Arial",
    fill: '#000',
    align: 'center'
  };

  Credits.prototype.preload = function() {};

  Credits.prototype.create = function() {
    this.add.sprite(0, 0, 'background');
    this.add.sprite(0, 0, 'icon');
    this.add.sprite(0, 10, 'quote');
    this.add.text(10, 150, this.text, this.style);
    this.add.button(this.game.width / 2 - 38, this.game.height - 80, 'backButton', this.goBack, this, 2, 1, 0);
    return this.add.text(50, this.game.height - 40, this.copyright, this.style);
  };

  Credits.prototype.goBack = function() {
    return this.state.start('Intro', true, false);
  };

  return Credits;

})(Phaser.State);