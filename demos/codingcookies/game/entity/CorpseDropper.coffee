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

Game.EntityMixins.CorpseDropper =
  name: "CorpseDropper"
  init: (template) ->
    
    # Chance of dropping a cropse (out of 100).
    @_corpseDropRate = template["corpseDropRate"] or 100

  listeners:
    onDeath: (attacker) ->
      
      # Check if we should drop a corpse.
      if Math.round(Math.random() * 100) <= @_corpseDropRate
        
        # Create a new corpse item and drop it.
        @_map.addItem @getX(), @getY(), @getZ(), Game.ItemRepository.create("corpse",
          name: @_name + " corpse"
          foreground: @_foreground
        )

