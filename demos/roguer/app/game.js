// Generated by CoffeeScript 1.7.1
var Game;

module.exports = Game = {
  _display: null,
  _currentScreen: null,
  _screenWidth: 80,
  _screenHeight: 24,
  init: function() {
    var bindEventToScreen;
    require('./game/Glyph');
    require('./game/DynamicGlyph');
    require('./game/Tile');
    require('./game/Builder');
    require('./game/Map');
    require('./game/map/Cave');
    require('./game/map/BossCavern');
    require('./game/screen/ItemListScreen');
    require('./game/screen/TargetBasedScreen');
    require('./game/Entity');
    require('./game/entity/PlayerActor');
    require('./game/entity/FungusActor');
    require('./game/entity/TaskActor');
    require('./game/entity/GiantZombieActor');
    require('./game/entity/Attacker');
    require('./game/entity/Destructible');
    require('./game/entity/MessageRecipient');
    require('./game/entity/Sight');
    require('./game/entity/InventoryHolder');
    require('./game/entity/FoodConsumer');
    require('./game/entity/CorpseDropper');
    require('./game/entity/Equipper');
    require('./game/entity/ExperienceGainer');
    require('./game/entity/RandomStatGainer');
    require('./game/entity/PlayerStatGainer');
    require('./game/Item');
    require('./game/item/Edible');
    require('./game/item/Equippable');
    require('./game/Repository');
    require('./data/screens/dropScreen');
    require('./data/screens/eatScreen');
    require('./data/screens/examineScreen');
    require('./data/screens/gainStatScreen');
    require('./data/screens/helpScreen');
    require('./data/screens/inventoryScreen');
    require('./data/screens/lookScreen');
    require('./data/screens/loseScreen');
    require('./data/screens/pickupScreen');
    require('./data/screens/playScreen');
    require('./data/screens/startScreen');
    require('./data/screens/wearScreen');
    require('./data/screens/wieldScreen');
    require('./data/screens/winScreen');
    require('./data/entities/PlayerTemplate');
    require('./data/entities/bat');
    require('./data/entities/fungus');
    require('./data/entities/giant_zombie');
    require('./data/entities/kobold');
    require('./data/entities/newt');
    require('./data/entities/slime');
    require('./data/items/apple');
    require('./data/items/melon');
    require('./data/items/pumpkin');
    require('./data/items/corpse');
    require('./data/items/rock');
    require('./data/items/dagger');
    require('./data/items/sword');
    require('./data/items/staff');
    require('./data/items/tunic');
    require('./data/items/chainmail');
    require('./data/items/platemail');
    this._display = new ROT.Display({
      width: this._screenWidth,
      height: this._screenHeight + 1
    });
    bindEventToScreen = (function(_this) {
      return function(event) {
        window.addEventListener(event, function(e) {
          if (_this._currentScreen != null) {
            _this._currentScreen.handleInput(event, e);
          }
        });
      };
    })(this);
    bindEventToScreen("keydown");
    bindEventToScreen("keypress");
  },
  getDisplay: function() {
    return this._display;
  },
  getScreenWidth: function() {
    return this._screenWidth;
  },
  getScreenHeight: function() {
    return this._screenHeight;
  },
  refresh: function() {
    this._display.clear();
    this._currentScreen.render(this._display);
  },
  switchScreen: function(screen) {
    if (this._currentScreen !== null) {
      this._currentScreen.exit();
    }
    this.getDisplay().clear();
    this._currentScreen = screen;
    if (!this._currentScreen !== null) {
      this._currentScreen.enter();
      this.refresh();
    }
  },
  merge: function(src, dest) {
    var key, result;
    result = {};
    for (key in src) {
      result[key] = src[key];
    }
    for (key in dest) {
      result[key] = dest[key];
    }
    return result;
  },
  getNeighborPositions: function(x, y) {
    var dX, dY, tiles, _i, _j;
    tiles = [];
    for (dX = _i = -1; _i < 2; dX = ++_i) {
      for (dY = _j = -1; _j < 2; dY = ++_j) {
        if (dX === 0 && dY === 0) {
          continue;
        }
        tiles.push({
          x: x + dX,
          y: y + dY
        });
      }
    }
    return tiles.randomize();
  },
  sendMessage: function(recipient, message, args) {
    if (recipient.hasMixin(Game.EntityMixins.MessageRecipient)) {
      if (args) {
        message = vsprintf(message, args);
      }
      return recipient.receiveMessage(message);
    }
  },
  sendMessageNearby: function(map, centerX, centerY, centerZ, message, args) {
    var entities, i, _results;
    if (args) {
      message = vsprintf(message, args);
    }
    entities = map.getEntitiesWithinRadius(centerX, centerY, centerZ, 5);
    i = 0;
    _results = [];
    while (i < entities.length) {
      if (entities[i].hasMixin(Game.EntityMixins.MessageRecipient)) {
        entities[i].receiveMessage(message);
      }
      _results.push(i++);
    }
    return _results;
  },
  getLine: function(startX, startY, endX, endY) {
    var dx, dy, e2, err, points, sx, sy;
    points = [];
    dx = Math.abs(endX - startX);
    dy = Math.abs(endY - startY);
    sx = (startX < endX ? 1 : -1);
    sy = (startY < endY ? 1 : -1);
    err = dx - dy;
    e2 = void 0;
    while (true) {
      points.push({
        x: startX,
        y: startY
      });
      if (startX === endX && startY === endY) {
        break;
      }
      e2 = err * 2;
      if (e2 > -dx) {
        err -= dy;
        startX += sx;
      }
      if (e2 < dx) {
        err += dx;
        startY += sy;
      }
    }
    return points;
  }
};