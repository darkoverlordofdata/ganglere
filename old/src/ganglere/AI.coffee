#+--------------------------------------------------------------------+
#| AI.coffee
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
# AI Utilities
#
"use strict"

ganglere = require('../ganglere')

# ----------------------------
# AI class
# ----------------------------
class ganglere.AI

  game: null
  
  reshuffle = [
    {x: -1, y:  0}
    {x:  1, y:  0}
    {x:  0, y: -1}
    {x:  0, y:  1}
    ]
  
  #
  # Wander in a random direction
  #
  # @return
  #
  wander = ->

    # Fisher-Yates shuffle algorithm
    i = reshuffle.length
    while --i > 0
      j = ~~(Math.random() * (i + 1))
      t = reshuffle[j]
      reshuffle[j] = reshuffle[i]
      reshuffle[i] = t
    reshuffle

  #
  # hunt for closest direction
  #
  # @param  [Number]  deltaX
  # @param  [Number]  deltaY
  # @return	array of directions sorted in closest order
  #
  hunt = (deltaX, deltaY) ->
  
    [ {x: -1, y:  0}
      {x:  1, y:  0}
      {x:  0, y: -1}
      {x:  0, y:  1}
    ].map((direction) ->
      x         : direction.x
      y         : direction.y
      distance  : Math.pow(deltaX + direction.x, 2) + Math.pow(deltaY + direction.y, 2)
    ).sort((a, b) -> b.distance - a.distance)



  constructor: (@game) ->
  

  #
  # Wander in a random direction
  #
  # @return	{x, y}
  #
  wander: (actor) ->
    for direction in wander()
      break if @game.moveTo(actor, direction)


  #
  # Hunt for the player
  #
  # @param  [ganglere.Actor]  enemy actor
  # @param  [Number]  deltaX
  # @param  [Number]  deltaY
  # @return	array of directions sorted in closest order
  #
  hunt: (actor, deltaX, deltaY) ->
    for direction in hunt(deltaX, deltaY)
      break if @game.moveTo(actor, direction)
  

