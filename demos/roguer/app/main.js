// Generated by CoffeeScript 1.7.1
window.onload = function() {
  var Game;
  if (ROT.isSupported()) {
    Game = require('./game');
    Game.init();
    document.body.appendChild(Game.getDisplay().getContainer());
    Game.switchScreen(Game.Screen.startScreen);
  } else {
    alert("The rot.js library isn't supported by your browser.");
  }
};
