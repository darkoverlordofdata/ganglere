#+--------------------------------------------------------------------+
#| entity.coffee
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
# Define the basic entity object
#
Game = require('./../game')

class Game.Entity extends Game.DynamicGlyph

  constructor: (properties) ->
    properties = properties or {}
    
    # Call the dynamic glyph's construtor with our set of properties
    super properties
    
    # Instantiate any properties from the passed object
    @_x = properties["x"] or 0
    @_y = properties["y"] or 0
    @_z = properties["z"] or 0
    @_map = null
    @_alive = true
    
    # Acting speed
    @_speed = properties["speed"] or 1000
    return
  
  
  setX: (x) ->
    @_x = x
    return
  
  setY: (y) ->
    @_y = y
    return
  
  setZ: (z) ->
    @_z = z
    return
  
  setMap: (map) ->
    @_map = map
    return
  
  setSpeed: (speed) ->
    @_speed = speed
    return
  
  setPosition: (x, y, z) ->
    oldX = @_x
    oldY = @_y
    oldZ = @_z
  
    # Update position
    @_x = x
    @_y = y
    @_z = z
    
    # If the entity is on a map, notify the map that the entity has moved.
    @_map.updateEntityPosition this, oldX, oldY, oldZ  if @_map
    return
  
  getX: ->
    @_x
  
  getY: ->
    @_y
  
  getZ: ->
    @_z
  
  getMap: ->
    @_map
  
  getSpeed: ->
    @_speed
  
  tryMove: (x, y, z, map) ->
    map = @getMap()
    
    # Must use starting z
    tile = map.getTile(x, y, @getZ())
    target = map.getEntityAt(x, y, @getZ())
    
    # If our z level changed, check if we are on stair
    if z < @getZ()
      unless tile is Game.Tile.stairsUpTile
        Game.sendMessage this, "You can't go up here!"
      else
        Game.sendMessage this, "You ascend to level %d!", [z + 1]
        @setPosition x, y, z
    else if z > @getZ()
      if tile is Game.Tile.holeToCavernTile and @hasMixin(Game.EntityMixins.PlayerActor)
        
        # Switch the entity to a boss cavern!
        @switchMap new Game.Map.BossCavern()
      else unless tile is Game.Tile.stairsDownTile
        Game.sendMessage this, "You can't go down here!"
      else
        @setPosition x, y, z
        Game.sendMessage this, "You descend to level %d!", [z + 1]
    
    # If an entity was present at the tile
    else if target
      
      # An entity can only attack if the entity has the Attacker mixin and 
      # either the entity or the target is the player.
      if @hasMixin("Attacker") and (@hasMixin(Game.EntityMixins.PlayerActor) or target.hasMixin(Game.EntityMixins.PlayerActor))
        @attack target
        return true
      
      # If not nothing we can do, but we can't 
      # move to the tile
      return false
    
    # Check if we can walk on the tile
    # and if so simply walk onto it
    else if tile.isWalkable()
      
      # Update the entity's position
      @setPosition x, y, z
      
      # Notify the entity that there are items at this position
      items = @getMap().getItemsAt(x, y, z)
      if items
        if items.length is 1
          Game.sendMessage this, "You see %s.", [items[0].describeA()]
        else
          Game.sendMessage this, "There are several objects here."
      return true
    
    # Check if the tile is diggable
    else if tile.isDiggable()
      
      # Only dig if the the entity is the player
      if @hasMixin(Game.EntityMixins.PlayerActor)
        map.dig x, y, z
        return true
      
      # If not nothing we can do, but we can't 
      # move to the tile
      return false
    false
  
  isAlive: ->
    @_alive
  
  kill: (message) ->
    
    # Only kill once!
    return  unless @_alive
    @_alive = false
    if message
      Game.sendMessage this, message
    else
      Game.sendMessage this, "You have died!"
    
    # Check if the player died, and if so call their act method to prompt the user.
    if @hasMixin(Game.EntityMixins.PlayerActor)
      @act()
    else
      @getMap().removeEntity this
    return
  
  switchMap: (newMap) ->
    
    # If it's the same map, nothing to do!
    return  if newMap is @getMap()
    @getMap().removeEntity this
    
    # Clear the position
    @_x = 0
    @_y = 0
    @_z = 0
    
    # Add to the new map
    newMap.addEntity this
    return


Game.EntityMixins = {}