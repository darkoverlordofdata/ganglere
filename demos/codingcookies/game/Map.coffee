#+--------------------------------------------------------------------+
#| map.coffee
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
# Define the map object
#
Game = require('./../game')

class Game.Map

  constructor: (tiles) ->
    @_tiles = tiles
    
    # Cache dimensions
    @_depth = tiles.length
    @_width = tiles[0].length
    @_height = tiles[0][0].length
    
    # Setup the field of visions
    @_fov = []
    @setupFov()
    
    # Create a table which will hold the entities
    @_entities = {}
    
    # Create a table which will hold the items
    @_items = {}
    
    # Create the engine and scheduler
    @_scheduler = new ROT.Scheduler.Speed()
    @_engine = new ROT.Engine(@_scheduler)
    
    # Setup the explored array
    @_explored = new Array(@_depth)
    @_setupExploredArray()
    return
  
  _setupExploredArray: ->
    z = 0
  
    while z < @_depth
      @_explored[z] = new Array(@_width)
      x = 0
  
      while x < @_width
        @_explored[z][x] = new Array(@_height)
        y = 0
  
        while y < @_height
          @_explored[z][x][y] = false
          y++
        x++
      z++
    return
  
  # Standard getters
  getDepth: ->
    @_depth
  
  getWidth: ->
    @_width
  
  getHeight: ->
    @_height
  
  
  # Gets the tile for a given coordinate set
  getTile: (x, y, z) ->
    
    # Make sure we are inside the bounds. If we aren't, return
    # null tile.
    if x < 0 or x >= @_width or y < 0 or y >= @_height or z < 0 or z >= @_depth
      Game.Tile.nullTile
    else
      @_tiles[z][x][y] or Game.Tile.nullTile
  
  dig: (x, y, z) ->
    
    # If the tile is diggable, update it to a floor
    @_tiles[z][x][y] = Game.Tile.floorTile  if @getTile(x, y, z).isDiggable()
    return
  
  isEmptyFloor: (x, y, z) ->
    
    # Check if the tile is floor and also has no entity
    @getTile(x, y, z) is Game.Tile.floorTile and not @getEntityAt(x, y, z)
  
  setExplored: (x, y, z, state) ->
    
    # Only update if the tile is within bounds
    @_explored[z][x][y] = state  if @getTile(x, y, z) isnt Game.Tile.nullTile
    return
  
  isExplored: (x, y, z) ->
    
    # Only return the value if within bounds
    if @getTile(x, y, z) isnt Game.Tile.nullTile
      @_explored[z][x][y]
    else
      false
  
  setupFov: ->
    
    # Keep this in 'map' variable so that we don't lose it.
    map = this
    
    # Iterate through each depth level, setting up the field of vision
    z = 0
  
    while z < @_depth
      
      # We have to put the following code in it's own scope to prevent the
      # depth variable from being hoisted out of the loop.
      (->
        
        # For each depth, we need to create a callback which figures out
        # if light can pass through a given tile.
        depth = z
        map._fov.push new ROT.FOV.DiscreteShadowcasting((x, y) ->
          not map.getTile(x, y, depth).isBlockingLight()
        ,
          topology: 4
        )
      )()
      z++
    return
  
  getFov: (depth) ->
    @_fov[depth]
  
  getEngine: ->
    @_engine
  
  getEntities: ->
    @_entities
  
  getEntityAt: (x, y, z) ->
    
    # Get the entity based on position key 
    @_entities[x + "," + y + "," + z]
  
  getEntitiesWithinRadius: (centerX, centerY, centerZ, radius) ->
    results = []
    
    # Determine our bounds
    leftX = centerX - radius
    rightX = centerX + radius
    topY = centerY - radius
    bottomY = centerY + radius
    
    # Iterate through our entities, adding any which are within the bounds
    for key of @_entities
      entity = @_entities[key]
      results.push entity  if entity.getX() >= leftX and entity.getX() <= rightX and entity.getY() >= topY and entity.getY() <= bottomY and entity.getZ() is centerZ
    results
  
  getRandomFloorPosition: (z) ->
    
    # Randomly generate a tile which is a floor
    x = undefined
    y = undefined
    loop
      x = Math.floor(Math.random() * @_width)
      y = Math.floor(Math.random() * @_height)
      break unless not @isEmptyFloor(x, y, z)
    x: x
    y: y
    z: z
  
  addEntityAtRandomPosition: (entity, z) ->
    position = @getRandomFloorPosition(z)
    entity.setX position.x
    entity.setY position.y
    entity.setZ position.z
    @addEntity entity
    return
  
  addEntity: (entity) ->
    
    # Update the entity's map
    entity.setMap this
    
    # Update the map with the entity's position
    @updateEntityPosition entity
    
    # Check if this entity is an actor, and if so add
    # them to the scheduler
    @_scheduler.add entity, true  if entity.hasMixin("Actor")
    
    # If the entity is the player, set the player.
    @_player = entity  if entity.hasMixin(Game.EntityMixins.PlayerActor)
    return
  
  removeEntity: (entity) ->
    
    # Remove the entity from the map
    key = entity.getX() + "," + entity.getY() + "," + entity.getZ()
    delete @_entities[key]  if @_entities[key] is entity
    
    # If the entity is an actor, remove them from the scheduler
    @_scheduler.remove entity  if entity.hasMixin("Actor")
    
    # If the entity is the player, update the player field.
    @_player = `undefined`  if entity.hasMixin(Game.EntityMixins.PlayerActor)
    return
  
  updateEntityPosition: (entity, oldX, oldY, oldZ) ->
    
    # Delete the old key if it is the same entity
    # and we have old positions.
    if typeof oldX is "number"
      oldKey = oldX + "," + oldY + "," + oldZ
      delete @_entities[oldKey]  if @_entities[oldKey] is entity
    
    # Make sure the entity's position is within bounds
    throw new Error("Entity's position is out of bounds.")  if entity.getX() < 0 or entity.getX() >= @_width or entity.getY() < 0 or entity.getY() >= @_height or entity.getZ() < 0 or entity.getZ() >= @_depth
    
    # Sanity check to make sure there is no entity at the new position.
    key = entity.getX() + "," + entity.getY() + "," + entity.getZ()
    throw new Error("Tried to add an entity at an occupied position.")  if @_entities[key]
    
    # Add the entity to the table of entities
    @_entities[key] = entity
    return
  
  getItemsAt: (x, y, z) ->
    @_items[x + "," + y + "," + z]
  
  setItemsAt: (x, y, z, items) ->
    
    # If our items array is empty, then delete the key from the table.
    key = x + "," + y + "," + z
    if items.length is 0
      delete @_items[key]  if @_items[key]
    else
      
      # Simply update the items at that key
      @_items[key] = items
    return
  
  addItem: (x, y, z, item) ->
    
    # If we already have items at that position, simply append the item to the 
    # list of items.
    key = x + "," + y + "," + z
    if @_items[key]
      @_items[key].push item
    else
      @_items[key] = [item]
    return
  
  addItemAtRandomPosition: (item, z) ->
    position = @getRandomFloorPosition(z)
    @addItem position.x, position.y, position.z, item
    return
  
  getPlayer: ->
    @_player
