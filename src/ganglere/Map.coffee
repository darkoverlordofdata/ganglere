#+--------------------------------------------------------------------+
#| Map.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Ganglere
#|
#| Ganglere is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Ganglere - The Deluding of Gylfe
#
# Map
#
"use strict"

ganglere = require('../ganglere')

# ----------------------------
# Map
# ----------------------------
class ganglere.Map

  options     : null      # config options for the current level
  tiles       : null      # used tiles map
  map         : null      # the Pahser.TileMap
  rot         : null      # generated Rogue dungeon
                          #
                          # properties loaded from tiled:
  height      : 0         # height in tiles
  width       : 0         # width in tiles
  imageheight : 0         # height in pixels of image
  imagewidth  : 0         # width in pixels of image
  tileheight  : 0         # height in pixels of tile
  tilewidth   : 0         # width in pixels of tile
  tileset     : ''        # name of the tileset
  wall        : 0         # index of dungeon wall tile
  space       : 0         # index of dungeon path tile
  artifacts   : null      # list of artifacts to use
  data        : null      # data to generate interest


  clone = (object) -> JSON.parse(JSON.stringify(object))
  
  #
  # Pair a tilemap to a generated Rogue dungeon
  #
  # @param [ganglere.Levels] level manager
  # @returns this
  #
  constructor: (@level) ->
  
    @options = @level.options

    # create the phaser framework tilemap
    @map = @level.add.tilemap(@loadTilemap(@options.map))
    @map.addTilesetImage @tileset, @tileset
    @map.createLayer('layer0', @level.game.width, @level.game.height-40).resizeWorld()
    @map.createLayer('layer1', @level.game.width, @level.game.height-40).resizeWorld()

    # init the used tiles map
    @tiles = JSON.parse(JSON.stringify(@rot.map))

  
  #
  # Load Tilemap
  #
  # Load a tiled json format tilemap
  # Merge ROT generated rogue dungeon
  #
  # @param [String] mapkey
  # @returns mapkey
  #
  loadTilemap: (mapkey) =>
    
    # start with basic building materials packed using Tiled
    
    json = @getProperties(clone(@level.cache.getJSON("#{mapkey}.json")))
    
    # mirror a generated rogue dungeon
    @rot = new ROT.Map.Rogue(@width, @height)
    @rot.create (x,y,v) =>
      json.layers[0].data[y * @width + x] = if v is 1 then @wall else @space
      
    # and decorate the place
    @addArtifacts json, @artifacts if @options.artifacts

    @level.cache.addTilemap mapkey,'', json
    mapkey
  
  
  #
  # Valid Move?
  #
  # @param [Object] from x,y
  # @param [Object] delta x,y 
  # @return	true/false
  #
  isValidMove: (from, delta) =>
    from.x+delta.x >= 0 and
      from.x+delta.x < @width and
      from.y+delta.y >= 0 and
      from.y+delta.y < @height and
      @tiles[from.x+delta.x][from.y+delta.y] is 0
  
  #
  # Light
  #
  # @return	Nothing
  #
  light:() =>
    @resetLight()

    @fov = new ROT.FOV.PreciseShadowcasting((x, y) =>
      typeof @tiles[x] is 'undefined' or typeof @tiles[x][y] is 'undefined' or @tiles[x][y] is 0
    )
    @computeLight()
  
  #
  # Reset Light
  #
  # @return	Nothing
  #
  resetLight:() =>
    return unless @options.hide is true
    for x in [0...@width]
      for y in [0...@height]
        tile = @map.getTile(x,y,0)
        tile.alpha = 0 if tile

        tile = @map.getTile(x,y,1)
        tile.alpha = 0 if tile

  #
  # Compute Light
  #
  # @return	Nothing
  #
  computeLight:() =>
  
    @resetLight()

    @level.actorList.forEach (a) ->
      a.sprite.alpha = 0

    @level.actorList[0].sprite.alpha=1
    @fov.compute @level.actorList[0].x, @level.actorList[0].y, 10, (x, y, r, visibility) =>
      tile = @map.getTile(x,y,0)
      tile.alpha = visibility if tile
      
      tile = @map.getTile(x,y,1)
      tile.alpha = visibility if tile
      
      if @level.actorMap.hasOwnProperty(x+'_'+y)
        @level.actorMap[x+'_'+y].sprite.alpha = visibility
      

    @map.layers[0].dirty = true
    @map.layers[1].dirty = true
  

  #
  # Get Properties
  #
  # Decorate the Map object with attributes from the json tilemap
  #
  # @param [Object] tilemap
  # @returns tilemap
  #
  getProperties: (tilemap) ->
  
    @width = tilemap.width
    @height = tilemap.height
    @tileset = tilemap.tilesets[0].name
    @imageheight = tilemap.tilesets[0].imageheight
    @imagewidth = tilemap.tilesets[0].imagewidth
    @tileheight = tilemap.tileheight
    @tilewidth = tilemap.tilewidth
    @backgroundcolor = tilemap.backgroundcolor
    
    if tilemap.properties.wall?
      @wall = parseInt(tilemap.properties.wall, 10)
    else
      @wall = 0
      
    if tilemap.properties.space?
      @space = parseInt(tilemap.properties.space, 10)
    else
      @space = (@imageheight/@tileheight)*(@imagewidth/@tilewidth)
    
    if tilemap.properties.artifacts?
      @artifacts = (tilemap.properties.artifacts).split(',').map (v) -> parseInt(v, 10)
    else
      @artifacts = []
    
    @data = {}
    for key, value of tilemap.properties
      if /^m\d\d\$/.test(key)
        @data[key.split('$')[1]] = value.split(',').map (v) -> parseInt(v, 10)
    
    tilemap
  

  #
  # Add Artifacts
  #
  # Make the walls more interesting...
  #
  # @param [Object] tilemap
  # @param [Object] artifacts
  # @returns tilemap
  #
  addArtifacts: (tilemap, artifacts) =>


    exist = (x,y) =>
      return if (typeof @rot.map[x] isnt 'undefined' and typeof @rot.map[x][y] isnt 'undefined' and @rot.map[x][y] is 0) then '1' else '0'

    patternArray = []
    
    for key, data of @data
      do (key, data) =>
        patternArray.push
          pattern : new RegExp(key.replace(/\_/g,'[0-1]'))
          setTile : (tilepos,x,y) =>
          
            if data[0]?
              tilemap.layers[1].data[tilepos] = data[0]
              if data[1]? and y>0
                tilemap.layers[1].data[(y-1)*@width+x]=data[1]
            else
              tilemap.layers[1].data[tilepos] = ganglere.Random.pick(artifacts) 
            
            

    for y in [0...@height]
      for x in [0...@width]
        continue if @rot.map[x][y] is 0

        tilepos = y * @width + x
        direction = 
          exist(x-1, y-1) +
          exist(x, y-1) +
          exist(x+1, y-1) +
          exist(x-1, y) + '1' +
          exist(x+1, y) +
          exist(x-1, y+1) +
          exist(x, y+1) +
          exist(x+1, y+1)
          
        for i in [0...patternArray.length]
          if patternArray[i].pattern.test(direction)
            patternArray[i].setTile(tilepos, x, y)
            break

    return tilemap
    
  