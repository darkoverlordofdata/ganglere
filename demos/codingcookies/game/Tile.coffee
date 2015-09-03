#+--------------------------------------------------------------------+
#| tile.coffee
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
# Define the basic tile object
#
Game = require('./../game')

class Game.Tile extends Game.Glyph

  constructor: (properties) ->
    properties = properties or {}
    
    # Call the Glyph constructor with our properties
    super properties
    
    # Set up the properties. We use false by default.
    @_walkable = properties["walkable"] or false
    @_diggable = properties["diggable"] or false
    @_blocksLight = (if (properties["blocksLight"] isnt `undefined`) then properties["blocksLight"] else true)
    @_description = properties["description"] or ""


  # Standard getters
  isWalkable: ->
    @_walkable
  
  isDiggable: ->
    @_diggable
  
  isBlockingLight: ->
    @_blocksLight
  
  getDescription: ->
    @_description
  
  Tile.nullTile = new Tile(description: "(unknown)")
  Tile.floorTile = new Tile(
    character: "."
    walkable: true
    blocksLight: false
    description: "A cave floor"
  )
  Tile.wallTile = new Tile(
    character: "#"
    foreground: "goldenrod"
    diggable: true
    description: "A cave wall"
  )
  Tile.stairsUpTile = new Tile(
    character: "<"
    foreground: "white"
    walkable: true
    blocksLight: false
    description: "A rock staircase leading upwards"
  )
  Tile.stairsDownTile = new Tile(
    character: ">"
    foreground: "white"
    walkable: true
    blocksLight: false
    description: "A rock staircase leading downwards"
  )
  Tile.holeToCavernTile = new Tile(
    character: "O"
    foreground: "white"
    walkable: true
    blocksLight: false
    description: "A great dark hole in the ground"
  )
  Tile.waterTile = new Tile(
    character: "~"
    foreground: "blue"
    walkable: false
    blocksLight: false
    description: "Murky blue water"
  )
  
