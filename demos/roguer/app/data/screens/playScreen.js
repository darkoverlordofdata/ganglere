// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

if (Game.Screen == null) {
  Game.Screen = {};
}

Game.Screen.playScreen = {
  _player: null,
  _gameEnded: false,
  _subScreen: null,
  enter: function() {
    var depth, height, map, tiles, width;
    width = 100;
    height = 48;
    depth = 6;
    this._player = new Game.Entity(Game.PlayerTemplate);
    tiles = new Game.Builder(width, height, depth).getTiles();
    map = new Game.Map.Cave(tiles, this._player);
    return map.getEngine().start();
  },
  exit: function() {
    return console.log("Exited play screen.");
  },
  render: function(display) {
    var hungerState, i, messageY, messages, screenHeight, screenWidth, stats;
    if (this._subScreen) {
      this._subScreen.render(display);
      return;
    }
    screenWidth = Game.getScreenWidth();
    screenHeight = Game.getScreenHeight();
    this.renderTiles(display);
    messages = this._player.getMessages();
    messageY = 0;
    i = 0;
    while (i < messages.length) {
      messageY += display.drawText(0, messageY, "%c{white}%b{black}" + messages[i]);
      i++;
    }
    stats = "%c{white}%b{black}";
    stats += vsprintf("HP: %d/%d L: %d XP: %d", [this._player.getHp(), this._player.getMaxHp(), this._player.getLevel(), this._player.getExperience()]);
    display.drawText(0, screenHeight, stats);
    hungerState = this._player.getHungerState();
    return display.drawText(screenWidth - hungerState.length, screenHeight, hungerState);
  },
  getScreenOffsets: function() {
    var topLeftX, topLeftY;
    topLeftX = Math.max(0, this._player.getX() - (Game.getScreenWidth() / 2));
    topLeftX = Math.min(topLeftX, this._player.getMap().getWidth() - Game.getScreenWidth());
    topLeftY = Math.max(0, this._player.getY() - (Game.getScreenHeight() / 2));
    topLeftY = Math.min(topLeftY, this._player.getMap().getHeight() - Game.getScreenHeight());
    return {
      x: topLeftX,
      y: topLeftY
    };
  },
  renderTiles: function(display) {
    var currentDepth, foreground, glyph, items, map, offsets, screenHeight, screenWidth, topLeftX, topLeftY, visibleCells, x, y, _results;
    screenWidth = Game.getScreenWidth();
    screenHeight = Game.getScreenHeight();
    offsets = this.getScreenOffsets();
    topLeftX = offsets.x;
    topLeftY = offsets.y;
    visibleCells = {};
    map = this._player.getMap();
    currentDepth = this._player.getZ();
    map.getFov(currentDepth).compute(this._player.getX(), this._player.getY(), this._player.getSightRadius(), function(x, y, radius, visibility) {
      visibleCells[x + "," + y] = true;
      return map.setExplored(x, y, currentDepth, true);
    });
    x = topLeftX;
    _results = [];
    while (x < topLeftX + screenWidth) {
      y = topLeftY;
      while (y < topLeftY + screenHeight) {
        if (map.isExplored(x, y, currentDepth)) {
          glyph = map.getTile(x, y, currentDepth);
          foreground = glyph.getForeground();
          if (visibleCells[x + "," + y]) {
            items = map.getItemsAt(x, y, currentDepth);
            if (items) {
              glyph = items[items.length - 1];
            }
            if (map.getEntityAt(x, y, currentDepth)) {
              glyph = map.getEntityAt(x, y, currentDepth);
            }
            foreground = glyph.getForeground();
          } else {
            foreground = "darkGray";
          }
          display.draw(x - topLeftX, y - topLeftY, glyph.getChar(), foreground, glyph.getBackground());
        }
        y++;
      }
      _results.push(x++);
    }
    return _results;
  },
  handleInput: function(inputType, inputData) {
    var item, items, keyChar, offsets;
    if (this._gameEnded) {
      if (inputType === "keydown" && inputData.keyCode === ROT.VK_RETURN) {
        Game.switchScreen(Game.Screen.loseScreen);
      }
      return;
    }
    if (this._subScreen) {
      this._subScreen.handleInput(inputType, inputData);
      return;
    }
    if (inputType === "keydown") {
      if (inputData.keyCode === ROT.VK_LEFT) {
        this.move(-1, 0, 0);
      } else if (inputData.keyCode === ROT.VK_RIGHT) {
        this.move(1, 0, 0);
      } else if (inputData.keyCode === ROT.VK_UP) {
        this.move(0, -1, 0);
      } else if (inputData.keyCode === ROT.VK_DOWN) {
        this.move(0, 1, 0);
      } else if (inputData.keyCode === ROT.VK_I) {
        this.showItemsSubScreen(Game.Screen.inventoryScreen, this._player.getItems(), "You are not carrying anything.");
        return;
      } else if (inputData.keyCode === ROT.VK_D) {
        this.showItemsSubScreen(Game.Screen.dropScreen, this._player.getItems(), "You have nothing to drop.");
        return;
      } else if (inputData.keyCode === ROT.VK_E) {
        this.showItemsSubScreen(Game.Screen.eatScreen, this._player.getItems(), "You have nothing to eat.");
        return;
      } else if (inputData.keyCode === ROT.VK_W) {
        if (inputData.shiftKey) {
          this.showItemsSubScreen(Game.Screen.wearScreen, this._player.getItems(), "You have nothing to wear.");
        } else {
          this.showItemsSubScreen(Game.Screen.wieldScreen, this._player.getItems(), "You have nothing to wield.");
        }
        return;
      } else if (inputData.keyCode === ROT.VK_X) {
        this.showItemsSubScreen(Game.Screen.examineScreen, this._player.getItems(), "You have nothing to examine.");
        return;
      } else if (inputData.keyCode === ROT.VK_COMMA) {
        items = this._player.getMap().getItemsAt(this._player.getX(), this._player.getY(), this._player.getZ());
        if (items && items.length === 1) {
          item = items[0];
          if (this._player.pickupItems([0])) {
            Game.sendMessage(this._player, "You pick up %s.", [item.describeA()]);
          } else {
            Game.sendMessage(this._player, "Your inventory is full! Nothing was picked up.");
          }
        } else {
          this.showItemsSubScreen(Game.Screen.pickupScreen, items, "There is nothing here to pick up.");
        }
      } else {
        return;
      }
      return this._player.getMap().getEngine().unlock();
    } else if (inputType === "keypress") {
      keyChar = String.fromCharCode(inputData.charCode);
      if (keyChar === ">") {
        this.move(0, 0, 1);
      } else if (keyChar === "<") {
        this.move(0, 0, -1);
      } else if (keyChar === ";") {
        offsets = this.getScreenOffsets();
        Game.Screen.lookScreen.setup(this._player, this._player.getX(), this._player.getY(), offsets.x, offsets.y);
        this.setSubScreen(Game.Screen.lookScreen);
        return;
      } else if (keyChar === "?") {
        this.setSubScreen(Game.Screen.helpScreen);
        return;
      } else {
        return;
      }
      return this._player.getMap().getEngine().unlock();
    }
  },
  move: function(dX, dY, dZ) {
    var newX, newY, newZ;
    newX = this._player.getX() + dX;
    newY = this._player.getY() + dY;
    newZ = this._player.getZ() + dZ;
    return this._player.tryMove(newX, newY, newZ, this._player.getMap());
  },
  setGameEnded: function(gameEnded) {
    return this._gameEnded = gameEnded;
  },
  setSubScreen: function(subScreen) {
    this._subScreen = subScreen;
    return Game.refresh();
  },
  showItemsSubScreen: function(subScreen, items, emptyMessage) {
    if (items && subScreen.setup(this._player, items) > 0) {
      return this.setSubScreen(subScreen);
    } else {
      Game.sendMessage(this._player, emptyMessage);
      return Game.refresh();
    }
  }
};
