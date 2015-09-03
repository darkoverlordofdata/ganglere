#+--------------------------------------------------------------------+
#| screens.coffee
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
# Define screens
#

Game = require('./../../game')

Game.Screen = {} unless Game.Screen?

Game.Screen.lookScreen = new Game.Screen.TargetBasedScreen(captionFunction: (x, y) ->
  z = @_player.getZ()
  map = @_player.getMap()
  
  # If the tile is explored, we can give a better capton
  if map.isExplored(x, y, z)
    
    # If the tile isn't explored, we have to check if we can actually 
    # see it before testing if there's an entity or item.
    if @_visibleCells[x + "," + y]
      items = map.getItemsAt(x, y, z)
      
      # If we have items, we want to render the top most item
      if items
        item = items[items.length - 1]
        return String.format("%s - %s (%s)", item.getRepresentation(), item.describeA(true), item.details())
      
      # Else check if there's an entity
      else if map.getEntityAt(x, y, z)
        entity = map.getEntityAt(x, y, z)
        return String.format("%s - %s (%s)", entity.getRepresentation(), entity.describeA(true), entity.details())
    
    # If there was no entity/item or the tile wasn't visible, then use
    # the tile information.
    String.format "%s - %s", map.getTile(x, y, z).getRepresentation(), map.getTile(x, y, z).getDescription()
  else
    
    # If the tile is not explored, show the null tile description.
    String.format "%s - %s", Game.Tile.nullTile.getRepresentation(), Game.Tile.nullTile.getDescription()
)
