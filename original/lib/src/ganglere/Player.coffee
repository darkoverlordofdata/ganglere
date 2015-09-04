#+--------------------------------------------------------------------+
#| Player.coffee
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
# Player
#
#
"use strict"

ganglere = require('../ganglere')

# ----------------------------
# Player
# ----------------------------
class ganglere.Player extends ganglere.Actor
  
  #
  # new Player Hero
  #
  # @param  [Phaser.State]  game state
  # @param  [Number]  x coord
  # @param  [Number]  y coord
  # @return	Nothing
  #
  constructor: (game, x, y) ->
    super game, x, y, game.player.sprite
    @hp = game.player.hp
    @damage = game.player.damage
    @isPlayer = true

  