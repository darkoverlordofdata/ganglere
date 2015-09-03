#+--------------------------------------------------------------------+
#| screens.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#|  ______
#|  | ___ \
#|  | |_/ /___   __ _ _   _  ___ _ __
#|  |    // _ \ / _` | | | |/ _ \ '__|
#|  | |\ \ (_) | (_| | |_| |  __/ |
#|  \_| \_\___/ \__, |\__,_|\___|_| a rogue like game
#|               __/ |
#|              |___/
#|
#| Roguer is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Define screens
#

Game = require('./../../game')

Game.Screen = {} unless Game.Screen?

Game.Screen.examineScreen = new Game.Screen.ItemListScreen(
  caption: "Choose the item you wish to examine"
  canSelect: true
  canSelectMultipleItems: false
  isAcceptable: (item) ->
    true

  ok: (selectedItems) ->
    keys = Object.keys(selectedItems)
    if keys.length > 0
      item = selectedItems[keys[0]]
      Game.sendMessage @_player, "It's %s (%s).", [
        item.describeA(false)
        item.details()
      ]
    true
)
