#+--------------------------------------------------------------------+
#| bosscavern.coffee
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
# Define the basic item object
#
Game = require('./../../game')

class Game.Map.BossCavern extends Game.Map
  
  constructor: ->
    
    # Call the Map constructor
    super @_generateTiles(80, 24)
    
    # Create the giant zombie
    @addEntityAtRandomPosition Game.EntityRepository.create("giant zombie"), 0
    return
  
  _fillCircle: (tiles, centerX, centerY, radius, tile) ->
    
    # Copied from the DrawFilledCircle algorithm
    # http://stackoverflow.com/questions/1201200/fast-algorithm-for-drawing-filled-circles
    x = radius
    y = 0
    xChange = 1 - (radius << 1)
    yChange = 0
    radiusError = 0
    while x >= y
      i = centerX - x
  
      while i <= centerX + x
        tiles[i][centerY + y] = tile
        tiles[i][centerY - y] = tile
        i++
      i = centerX - y
  
      while i <= centerX + y
        tiles[i][centerY + x] = tile
        tiles[i][centerY - x] = tile
        i++
      y++
      radiusError += yChange
      yChange += 2
      if ((radiusError << 1) + xChange) > 0
        x--
        radiusError += xChange
        xChange += 2
    return
  
  _generateTiles: (width, height) ->
    
    # First we create an array, filling it with empty tiles.
    tiles = new Array(width)
    x = 0
  
    while x < width
      tiles[x] = new Array(height)
      y = 0
  
      while y < height
        tiles[x][y] = Game.Tile.wallTile
        y++
      x++
    
    # Now we determine the radius of the cave to carve out.
    radius = (Math.min(width, height) - 2) / 2
    @_fillCircle tiles, width / 2, height / 2, radius, Game.Tile.floorTile
    
    # Now we randomly position lakes (3 - 6 lakes)
    lakes = Math.round(Math.random() * 3) + 3
    maxRadius = 2
    i = 0
  
    while i < lakes
      
      # Random position, taking into consideration the radius to make sure
      # we are within the bounds.
      centerX = Math.floor(Math.random() * (width - (maxRadius * 2)))
      centerY = Math.floor(Math.random() * (height - (maxRadius * 2)))
      centerX += maxRadius
      centerY += maxRadius
      
      # Random radius
      radius = Math.floor(Math.random() * maxRadius) + 1
      
      # Position the lake!
      @_fillCircle tiles, centerX, centerY, radius, Game.Tile.waterTile
      i++
    
    # Return the tiles in an array as we only have 1 depth level.
    [tiles]
  
  addEntity: (entity) ->
    
    # Call super method.
    super entity
    
    # If it's a player, place at random position
    if @getPlayer() is entity
      position = @getRandomFloorPosition(0)
      entity.setPosition position.x, position.y, 0
      
      # Start the engine!
      @getEngine().start()
      return
