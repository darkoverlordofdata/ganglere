#+--------------------------------------------------------------------+
#| cavern.coffee
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

class Game.Map.Cave extends Game.Map

  constructor: (tiles, player) ->
  
    # Call the Map constructor
    super tiles

    # Add the player
    @addEntityAtRandomPosition player, 0

    # Add random entities and items to each floor.
    z = 0

    while z < @_depth

      # 15 entities per floor
      i = 0

      while i < 15
        entity = Game.EntityRepository.createRandom()

        # Add a random entity
        @addEntityAtRandomPosition entity, z

        # Level up the entity based on the floor
        if entity.hasMixin("ExperienceGainer")
          level = 0

          while level < z
            entity.giveExperience entity.getNextLevelExperience() - entity.getExperience()
            level++
        i++

      # 15 items per floor
      i = 0

      while i < 15

        # Add a random entity
        @addItemAtRandomPosition Game.ItemRepository.createRandom(), z
        i++
      z++

    # Add weapons and armor to the map in random positions and floors
    templates = [
      "dagger"
      "sword"
      "staff"
      "tunic"
      "chainmail"
      "platemail"
    ]
    i = 0

    while i < templates.length
      @addItemAtRandomPosition Game.ItemRepository.create(templates[i]), Math.floor(@_depth * Math.random())
      i++

    # Add a hole to the final cavern on the last level.
    holePosition = @getRandomFloorPosition(@_depth - 1)
    @_tiles[@_depth - 1][holePosition.x][holePosition.y] = Game.Tile.holeToCavernTile
    return

