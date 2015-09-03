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


# This signifies our entity posseses a field of vision of a given radius.
Game.EntityMixins.Sight =
  name: "Sight"
  groupName: "Sight"
  init: (template) ->
    @_sightRadius = template["sightRadius"] or 5

  getSightRadius: ->
    @_sightRadius

  increaseSightRadius: (value) ->

    # If no value was passed, default to 1.
    value = value or 1

    # Add to sight radius.
    @_sightRadius += value
    Game.sendMessage this, "You are more aware of your surroundings!"

  canSee: (entity) ->

    # If not on the same map or on different floors, then exit early
    return false  if not entity or @_map isnt entity.getMap() or @_z isnt entity.getZ()
    otherX = entity.getX()
    otherY = entity.getY()

    # If we're not in a square field of view, then we won't be in a real
    # field of view either.
    return false  if (otherX - @_x) * (otherX - @_x) + (otherY - @_y) * (otherY - @_y) > @_sightRadius * @_sightRadius

    # Compute the FOV and check if the coordinates are in there.
    found = false
    @getMap().getFov(@getZ()).compute @getX(), @getY(), @getSightRadius(), (x, y, radius, visibility) ->
      found = true  if x is otherX and y is otherY

    found

