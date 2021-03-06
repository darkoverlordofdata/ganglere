// Generated by CoffeeScript 1.7.1
var Game;

Game = require('./../../game');

Game.EntityMixins.MessageRecipient = {
  name: "MessageRecipient",
  init: function(template) {
    return this._messages = [];
  },
  receiveMessage: function(message) {
    return this._messages.push(message);
  },
  getMessages: function() {
    return this._messages;
  },
  clearMessages: function() {
    return this._messages = [];
  }
};
