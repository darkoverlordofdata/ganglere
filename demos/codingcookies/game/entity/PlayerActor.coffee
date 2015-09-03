#+--------------------------------------------------------------------+
#| entitymixins.coffee
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
# Define mixins
#

Game = require('./../../game')

# Main player's actor mixin
Game.EntityMixins.PlayerActor =
  name: "PlayerActor"
  groupName: "Actor"
  act: ->
    return  if @_acting
    @_acting = true
    @addTurnHunger()
    
    # Detect if the game is over
    unless @isAlive()
      Game.Screen.playScreen.setGameEnded true
      
      # Send a last message to the player
      Game.sendMessage this, "Press [Enter] to continue!"
    
    # Re-render the screen
    Game.refresh()
    
    # Lock the engine and wait asynchronously
    # for the player to press a key.
    @getMap().getEngine().lock()
    
    # Clear the message queue
    @clearMessages()
    @_acting = false
    return

