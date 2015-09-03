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
Game.EntityMixins.RandomStatGainer =
  name: "RandomStatGainer"
  groupName: "StatGainer"
  listeners:
    onGainLevel: ->
      statOptions = @getStatOptions()
      
      # Randomly select a stat option and execute the callback for each
      # stat point.
      while @getStatPoints() > 0
        
        # Call the stat increasing function with this as the context.
        statOptions.random()[1].call this
        @setStatPoints @getStatPoints() - 1

