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

Game.Screen.pickupScreen = new Game.Screen.ItemListScreen(
  caption: "Choose the items you wish to pickup"
  canSelect: true
  canSelectMultipleItems: true
  ok: (selectedItems) ->
    
    # Try to pick up all items, messaging the player if they couldn't all be
    # picked up.
    Game.sendMessage @_player, "Your inventory is full! Not all items were picked up."  unless @_player.pickupItems(Object.keys(selectedItems))
    true
)
