#+--------------------------------------------------------------------+
#| Random.coffee
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
# Random Utilities
#
"use strict"

ganglere = require('../ganglere')

# ----------------------------
# Random class
# ----------------------------
class ganglere.Random

  #
  # Pick a random argument
  #
  # @param  [Array]  array
  # @return	a random argument
  #
  @pick: (array) ->
    array[Math.floor((Math.random()*array.length))]


  #
  # Dice Roll
  #
  # @param  [String]  data
  # @return	object
  #
  @diceRoll: (data) ->
    
    # data val sample '1d8+12'
    # data val sample '4d8-10'
    # data val sample 'd8+2'
    data = " " + data
    dataSplit = data.split(/-|\+|d/g)
    dices = parseInt(dataSplit[0], 10)
    dices = 1  unless dices
    sides = parseInt(dataSplit[1], 10)
    ret =
      diceRoll: []
      number: 0
      bonus: 0

    ret.number = 0
    n = undefined
    i = 0

    while i < dices
      n = 1 + Math.floor(Math.random() * sides)
      ret.diceRoll.push n
      ret.number += n
      i++
    if dataSplit[2]
      ret.bonus = parseInt(dataSplit[2], 10)
      ret.bonus = ret.bonus * -1  if data.indexOf("-") > -1
    ret.total = ret.number + ret.bonus
    ret
    

