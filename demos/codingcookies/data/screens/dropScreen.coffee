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

Game.Screen.dropScreen = new Game.Screen.ItemListScreen(
  caption: "Choose the item you wish to drop"
  canSelect: true
  canSelectMultipleItems: false
  ok: (selectedItems) ->
    
    # Drop the selected item
    @_player.dropItem Object.keys(selectedItems)[0]
    true
)
