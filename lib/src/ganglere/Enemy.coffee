#+--------------------------------------------------------------------+
#| Enemy.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| @ file is a part of Ganglere
#|
#| Ganglere is free software you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Ganglere - The Deluding of Gylfe
#
# Enemy
#
#
"use strict"

ganglere = require('../ganglere')

# ----------------------------
# Enemy
# ----------------------------
class ganglere.Enemy extends ganglere.Actor
  
  ai          : null        # AI implementation used by the game
  
  #
  # new Enemy
  #
  # @param  [Phaser.State]  game state
  # @param  [Number]  x coord
  # @param  [Number]  y coord
  # @return	Nothing
  #
  constructor: (game, x, y) ->
    super game, x, y, game.enemy.sprite
    @hp = game.enemy.hp
    @damage = game.enemy.damage
    @isPlayer = false
    @ai = new ganglere.AI(game)
    

  move: (player) =>
    deltaX = player.x - @x
    deltaY = player.y - @y

    if Math.abs(deltaX) + Math.abs(deltaY) > 6
      @ai.wander this
    else
      @ai.hunt this, deltaX, deltaY
  