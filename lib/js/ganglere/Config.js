// Generated by CoffeeScript 1.10.0
"use strict";
var Config, FRAME_BACK, FRAME_FRONT, FRAME_LEFT, FRAME_RIGHT, ganglere;

FRAME_FRONT = 0;

FRAME_BACK = 1;

FRAME_RIGHT = 2;

FRAME_LEFT = 3;

ganglere = require("../ganglere");

ganglere.config = new (Config = (function() {
  function Config() {}

  Config.prototype.FRAME_FRONT = FRAME_FRONT;

  Config.prototype.FRAME_BACK = FRAME_BACK;

  Config.prototype.FRAME_RIGHT = FRAME_RIGHT;

  Config.prototype.FRAME_LEFT = FRAME_LEFT;

  Config.prototype.name = 'The Deluding of Gylfe';

  Config.prototype.sprites = {
    'forest-tiles': {
      file: 'assets/images/foresttiles_0.png',
      width: 32,
      height: 32,
      cols: 5,
      rows: 7
    },
    heroes: {
      file: ['assets/sprites/Heroes/Fighter-F-01.png', 'assets/sprites/Heroes/Fighter-F-02.png', 'assets/sprites/Heroes/Fighter-M-01.png', 'assets/sprites/Heroes/Fighter-M-02.png', 'assets/sprites/Heroes/Healer-F-01.png', 'assets/sprites/Heroes/Healer-M-01.png', 'assets/sprites/Heroes/Mage-F-01.png', 'assets/sprites/Heroes/Mage-M-01.png', 'assets/sprites/Heroes/Ranger-F-01.png', 'assets/sprites/Heroes/Ranger-M-01.png'],
      selected: 9,
      width: 24,
      height: 32,
      cols: 6,
      rows: 4,
      type: 1,
      axis: 0,
      order: [FRAME_RIGHT, FRAME_FRONT, FRAME_BACK, FRAME_LEFT]
    },
    fenris: {
      file: 'assets/images/wolves.png',
      width: 32,
      height: 32,
      cols: 3,
      rows: 4,
      type: 1,
      axis: 0,
      order: [FRAME_FRONT, FRAME_LEFT, FRAME_RIGHT, FRAME_BACK]
    },
    loke: {
      file: ['assets/images/ogres1.png', 'assets/images/ogres2.png'],
      selected: 1,
      width: 32,
      height: 32,
      cols: 4,
      rows: 4,
      type: 0,
      axis: 3,
      order: [FRAME_FRONT, FRAME_LEFT, FRAME_BACK, FRAME_RIGHT]
    },
    thor: {
      file: ['assets/images/ogres1.png', 'assets/images/ogres2.png'],
      selected: 1,
      width: 32,
      height: 32,
      cols: 4,
      rows: 4,
      type: 0,
      axis: 2,
      order: [FRAME_FRONT, FRAME_LEFT, FRAME_BACK, FRAME_RIGHT]
    }
  };

  Config.prototype.levels = {
    Fenris: {
      title: 'Fenris at the Gate',
      options: {
        actors: 20,
        map: 'fenris',
        hide: false,
        artifacts: false
      },
      player: {
        hp: 60,
        sprite: "heroes",
        damage: "d6+2"
      },
      enemy: {
        hp: 5,
        sprite: "fenris",
        damage: "d2+0"
      }
    },
    Loke: {
      title: 'Combat with Loke',
      options: {
        actors: 10,
        map: 'loke',
        hide: false,
        artifacts: false
      },
      player: {
        hp: 200,
        sprite: "heroes",
        damage: "d6+2"
      },
      enemy: {
        hp: 5,
        sprite: "loke",
        damage: "d2+1"
      }
    },
    Thor: {
      title: 'Thor beats your a$$!',
      options: {
        actors: 25,
        map: 'thor',
        hide: true,
        artifacts: false
      },
      player: {
        hp: 500,
        sprite: "heroes",
        damage: "d6+2"
      },
      enemy: {
        hp: 5,
        sprite: "thor",
        damage: "d2+2"
      }
    }
  };

  return Config;

})());
