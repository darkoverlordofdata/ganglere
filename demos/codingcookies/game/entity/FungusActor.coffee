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

Game.EntityMixins.FungusActor =
  name: "FungusActor"
  groupName: "Actor"
  init: ->
    @_growthsRemaining = 5

  act: ->
    
    # Check if we are going to try growing this turn
    if @_growthsRemaining > 0
      if Math.random() <= 0.02
        
        # Generate the coordinates of a random adjacent square by
        # generating an offset between [-1, 0, 1] for both the x and
        # y directions. To do this, we generate a number from 0-2 and then
        # subtract 1.
        xOffset = Math.floor(Math.random() * 3) - 1
        yOffset = Math.floor(Math.random() * 3) - 1
        
        # Make sure we aren't trying to spawn on the same tile as us
        if xOffset isnt 0 or yOffset isnt 0
          
          # Check if we can actually spawn at that location, and if so
          # then we grow!
          if @getMap().isEmptyFloor(@getX() + xOffset, @getY() + yOffset, @getZ())
            entity = Game.EntityRepository.create("fungus")
            entity.setPosition @getX() + xOffset, @getY() + yOffset, @getZ()
            @getMap().addEntity entity
            @_growthsRemaining--
            
            # Send a message nearby!
            Game.sendMessageNearby @getMap(), entity.getX(), entity.getY(), entity.getZ(), "The fungus is spreading!"

