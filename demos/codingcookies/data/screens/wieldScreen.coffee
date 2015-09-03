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

Game.Screen.wieldScreen = new Game.Screen.ItemListScreen(
  caption: "Choose the item you wish to wield"
  canSelect: true
  canSelectMultipleItems: false
  hasNoItemOption: true
  isAcceptable: (item) ->
    item and item.hasMixin("Equippable") and item.isWieldable()

  ok: (selectedItems) ->
    
    # Check if we selected 'no item'
    keys = Object.keys(selectedItems)
    if keys.length is 0
      @_player.unwield()
      Game.sendMessage @_player, "You are empty handed."
    else
      
      # Make sure to unequip the item first in case it is the armor.
      item = selectedItems[keys[0]]
      @_player.unequip item
      @_player.wield item
      Game.sendMessage @_player, "You are wielding %s.", [item.describeA()]
    true
)
