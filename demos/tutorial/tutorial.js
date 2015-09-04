// Generated by CoffeeScript 1.6.3
var Game, Pedro, Player;

Game = {
  display: null,
  map: {},
  engine: null,
  player: null,
  pedro: null,
  ananas: null,
  init: function() {
    var scheduler;
    this.display = new ROT.Display({
      spacing: 1.1
    });
    document.body.appendChild(this.display.getContainer());
    this.generateMap();
    scheduler = new ROT.Scheduler.Simple();
    scheduler.add(this.player, true);
    scheduler.add(this.pedro, true);
    this.engine = new ROT.Engine(scheduler);
    return this.engine.start();
  },
  generateMap: function() {
    var digger, freeCells,
      _this = this;
    digger = new ROT.Map.Digger();
    freeCells = [];
    digger.create(function(x, y, value) {
      var key;
      if (value) {
        return;
      }
      key = x + "," + y;
      _this.map[key] = ".";
      return freeCells.push(key);
    });
    this.generateBoxes(freeCells);
    this.drawWholeMap();
    this.player = this.createBeing(Player, freeCells);
    return this.pedro = this.createBeing(Pedro, freeCells);
  },
  createBeing: function(BeingClass, freeCells) {
    var index, key, parts, x, y;
    index = Math.floor(ROT.RNG.getUniform() * freeCells.length);
    key = freeCells.splice(index, 1)[0];
    parts = key.split(",");
    x = parseInt(parts[0]);
    y = parseInt(parts[1]);
    return new BeingClass(x, y);
  },
  generateBoxes: function(freeCells) {
    var i, index, key;
    i = 0;
    while (i < 10) {
      index = Math.floor(ROT.RNG.getUniform() * freeCells.length);
      key = freeCells.splice(index, 1)[0];
      this.map[key] = "*";
      if (!i) {
        this.ananas = key;
      }
      i++;
    }
  },
  drawWholeMap: function() {
    var key, parts, x, y;
    for (key in this.map) {
      parts = key.split(",");
      x = parseInt(parts[0]);
      y = parseInt(parts[1]);
      this.display.draw(x, y, this.map[key]);
    }
  }
};

Player = (function() {
  function Player(x, y) {
    this.x = x;
    this.y = y;
    this.draw();
  }

  Player.prototype.getSpeed = function() {
    return 100;
  };

  Player.prototype.getX = function() {
    return this.x;
  };

  Player.prototype.getY = function() {
    return this.y;
  };

  Player.prototype.act = function() {
    Game.engine.lock();
    return window.addEventListener("keydown", this);
  };

  Player.prototype.handleEvent = function(e) {
    var code, dir, keyMap, newKey, newX, newY;
    code = e.keyCode;
    if (code === 13 || code === 32) {
      this.checkBox();
      return;
    }
    keyMap = {};
    keyMap[38] = 0;
    keyMap[33] = 1;
    keyMap[39] = 2;
    keyMap[34] = 3;
    keyMap[40] = 4;
    keyMap[35] = 5;
    keyMap[37] = 6;
    keyMap[36] = 7;
    if (!(code in keyMap)) {
      return;
    }
    dir = ROT.DIRS[8][keyMap[code]];
    newX = this.x + dir[0];
    newY = this.y + dir[1];
    newKey = newX + "," + newY;
    if (!(newKey in Game.map)) {
      return;
    }
    Game.display.draw(this.x, this.y, Game.map[this.x + "," + this.y]);
    this.x = newX;
    this.y = newY;
    this.draw();
    window.removeEventListener("keydown", this);
    return Game.engine.unlock();
  };

  Player.prototype.draw = function() {
    return Game.display.draw(this.x, this.y, "@", "#ff0");
  };

  Player.prototype.checkBox = function() {
    var key;
    key = this.x + "," + this.y;
    if (Game.map[key] !== "*") {
      return alert("There is no box here!");
    } else if (key === Game.ananas) {
      alert("Hooray! You found an ananas and won this game.");
      Game.engine.lock();
      return window.removeEventListener("keydown", this);
    } else {
      return alert("This box is empty :-(");
    }
  };

  return Player;

})();

Pedro = (function() {
  function Pedro(x, y) {
    this.x = x;
    this.y = y;
    this.draw();
  }

  Pedro.prototype.getSpeed = function() {
    return 100;
  };

  Pedro.prototype.act = function() {
    var astar, passableCallback, path, pathCallback, x, y;
    x = Game.player.getX();
    y = Game.player.getY();
    passableCallback = function(x, y) {
      return x + "," + y in Game.map;
    };
    astar = new ROT.Path.AStar(x, y, passableCallback, {
      topology: 4
    });
    path = [];
    pathCallback = function(x, y) {
      return path.push([x, y]);
    };
    astar.compute(this.x, this.y, pathCallback);
    path.shift();
    if (path.length === 1) {
      Game.engine.lock();
      return alert("Game over - you were captured by Pedro!");
    } else {
      x = path[0][0];
      y = path[0][1];
      Game.display.draw(this.x, this.y, Game.map[this.x + "," + this.y]);
      this.x = x;
      this.y = y;
      return this.draw();
    }
  };

  Pedro.prototype.draw = function() {
    return Game.display.draw(this.x, this.y, "P", "red");
  };

  return Pedro;

})();