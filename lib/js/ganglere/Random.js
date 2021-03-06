// Generated by CoffeeScript 1.10.0
"use strict";
var ganglere;

ganglere = require('../ganglere');

ganglere.Random = (function() {
  function Random() {}

  Random.pick = function(array) {
    return array[Math.floor(Math.random() * array.length)];
  };

  Random.diceRoll = function(data) {
    var dataSplit, dices, i, n, ret, sides;
    data = " " + data;
    dataSplit = data.split(/-|\+|d/g);
    dices = parseInt(dataSplit[0], 10);
    if (!dices) {
      dices = 1;
    }
    sides = parseInt(dataSplit[1], 10);
    ret = {
      diceRoll: [],
      number: 0,
      bonus: 0
    };
    ret.number = 0;
    n = void 0;
    i = 0;
    while (i < dices) {
      n = 1 + Math.floor(Math.random() * sides);
      ret.diceRoll.push(n);
      ret.number += n;
      i++;
    }
    if (dataSplit[2]) {
      ret.bonus = parseInt(dataSplit[2], 10);
      if (data.indexOf("-") > -1) {
        ret.bonus = ret.bonus * -1;
      }
    }
    ret.total = ret.number + ret.bonus;
    return ret;
  };

  return Random;

})();
