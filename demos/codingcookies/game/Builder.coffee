#+--------------------------------------------------------------------+
#| dynamicglyph.coffee
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
# Define the builder object
#

Game = require('./../game')

class Game.Builder

  constructor: (width, height, depth) ->
    @_width = width
    @_height = height
    @_depth = depth
    @_tiles = new Array(depth)
    @_regions = new Array(depth)
    
    # Instantiate the arrays to be multi-dimension
    z = 0
  
    while z < depth
      
      # Create a new cave at each level
      @_tiles[z] = @_generateLevel()
      
      # Setup the regions array for each depth
      @_regions[z] = new Array(width)
      x = 0
  
      while x < width
        @_regions[z][x] = new Array(height)
        
        # Fill with zeroes
        y = 0
  
        while y < height
          @_regions[z][x][y] = 0
          y++
        x++
      z++
    z = 0
  
    while z < @_depth
      @_setupRegions z
      z++
    @_connectAllRegions()
    return
  
  getTiles: ->
    @_tiles
  
  getDepth: ->
    @_depth
  
  getWidth: ->
    @_width
  
  getHeight: ->
    @_height
  
  _generateLevel: ->
    
    # Create the empty map
    map = new Array(@_width)
    w = 0
  
    while w < @_width
      map[w] = new Array(@_height)
      w++
    
    # Setup the cave generator
    generator = new ROT.Map.Cellular(@_width, @_height)
    generator.randomize 0.5
    totalIterations = 3
    
    # Iteratively smoothen the map
    i = 0
  
    while i < totalIterations - 1
      generator.create()
      i++
    
    # Smoothen it one last time and then update our map
    generator.create (x, y, v) ->
      if v is 1
        map[x][y] = Game.Tile.floorTile
      else
        map[x][y] = Game.Tile.wallTile
  
    map
  
  _canFillRegion: (x, y, z) ->
    
    # Make sure the tile is within bounds
    return false  if x < 0 or y < 0 or z < 0 or x >= @_width or y >= @_height or z >= @_depth
    
    # Make sure the tile does not already have a region
    return false  unless @_regions[z][x][y] is 0
    
    # Make sure the tile is walkable
    @_tiles[z][x][y].isWalkable()
  
  _fillRegion: (region, x, y, z) ->
    tilesFilled = 1
    tiles = [
      x: x
      y: y
    ]
    tile = undefined
    neighbors = undefined
    
    # Update the region of the original tile
    @_regions[z][x][y] = region
    
    # Keep looping while we still have tiles to process
    while tiles.length > 0
      tile = tiles.pop()
      
      # Get the neighbors of the tile
      neighbors = Game.getNeighborPositions(tile.x, tile.y)
      
      # Iterate through each neighbor, checking if we can use it to fill
      # and if so updating the region and adding it to our processing
      # list.
      while neighbors.length > 0
        tile = neighbors.pop()
        if @_canFillRegion(tile.x, tile.y, z)
          @_regions[z][tile.x][tile.y] = region
          tiles.push tile
          tilesFilled++
    tilesFilled
  
  
  # This removes all tiles at a given depth level with a region number.
  # It fills the tiles with a wall tile.
  _removeRegion: (region, z) ->
    x = 0
  
    while x < @_width
      y = 0
  
      while y < @_height
        if @_regions[z][x][y] is region
          
          # Clear the region and set the tile to a wall tile
          @_regions[z][x][y] = 0
          @_tiles[z][x][y] = Game.Tile.wallTile
        y++
      x++
    return
  
  # This sets up the regions for a given depth level.
  _setupRegions: (z) ->
    region = 1
    tilesFilled = undefined
    
    # Iterate through all tiles searching for a tile that
    # can be used as the starting point for a flood fill
    x = 0
  
    while x < @_width
      y = 0
  
      while y < @_height
        if @_canFillRegion(x, y, z)
          
          # Try to fill
          tilesFilled = @_fillRegion(region, x, y, z)
          
          # If it was too small, simply remove it
          if tilesFilled <= 20
            @_removeRegion region, z
          else
            region++
        y++
      x++
    return
  
  
  # This fetches a list of points that overlap between one
  # region at a given depth level and a region at a level beneath it.
  _findRegionOverlaps: (z, r1, r2) ->
    matches = []
    
    # Iterate through all tiles, checking if they respect
    # the region constraints and are floor tiles. We check
    # that they are floor to make sure we don't try to
    # put two stairs on the same tile.
    x = 0
  
    while x < @_width
      y = 0
  
      while y < @_height
        if @_tiles[z][x][y] is Game.Tile.floorTile and @_tiles[z + 1][x][y] is Game.Tile.floorTile and @_regions[z][x][y] is r1 and @_regions[z + 1][x][y] is r2
          matches.push
            x: x
            y: y
  
        y++
      x++
    
    # We shuffle the list of matches to prevent bias
    matches.randomize()
  
  
  # This tries to connect two regions by calculating 
  # where they overlap and adding stairs
  _connectRegions: (z, r1, r2) ->
    overlap = @_findRegionOverlaps(z, r1, r2)
    
    # Make sure there was overlap
    return false  if overlap.length is 0
    
    # Select the first tile from the overlap and change it to stairs
    point = overlap[0]
    @_tiles[z][point.x][point.y] = Game.Tile.stairsDownTile
    @_tiles[z + 1][point.x][point.y] = Game.Tile.stairsUpTile
    true
  
  
  # This tries to connect all regions for each depth level,
  # starting from the top most depth level.
  _connectAllRegions: ->
    z = 0
  
    while z < @_depth - 1
      
      # Iterate through each tile, and if we haven't tried
      # to connect the region of that tile on both depth levels
      # then we try. We store connected properties as strings
      # for quick lookups.
      connected = {}
      key = undefined
      x = 0
  
      while x < @_width
        y = 0
  
        while y < @_height
          key = @_regions[z][x][y] + "," + @_regions[z + 1][x][y]
          if @_tiles[z][x][y] is Game.Tile.floorTile and @_tiles[z + 1][x][y] is Game.Tile.floorTile and not connected[key]
            
            # Since both tiles are floors and we haven't 
            # already connected the two regions, try now.
            @_connectRegions z, @_regions[z][x][y], @_regions[z + 1][x][y]
            connected[key] = true
          y++
        x++
      z++
    return