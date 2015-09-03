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

Game.Screen.eatScreen = new Game.Screen.ItemListScreen(
  caption: "Choose the item you wish to eat"
  canSelect: true
  canSelectMultipleItems: false
  isAcceptable: (item) ->
    item and item.hasMixin("Edible")

  ok: (selectedItems) ->
    
    # Eat the item, removing it if there are no consumptions remaining.
    key = Object.keys(selectedItems)[0]
    item = selectedItems[key]
    Game.sendMessage @_player, "You eat %s.", [item.describeThe()]
    item.eat @_player
    @_player.removeItem key  unless item.hasRemainingConsumptions()
    true
)
