#+--------------------------------------------------------------------+
#| Scores.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Ganglere
#|
#| Ganglere is free software you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Ganglere - The Deluding of Gylfe
#
# Scores Screen
#
"use strict"

ganglere = require('../ganglere')


# ----------------------------
# Display high scores
# ----------------------------
class ganglere.Scores extends Phaser.State


  #
  # Phaser.State::preload
  #
  # @return	Nothing
  #
  preload: () ->


#
  # Phaser.State::create
  #
  # @return	Nothing
  #
  create: () ->
    @add.sprite 0, 0, 'background'
    @add.sprite 0, 0, 'icon'
    @add.sprite 0, 10, 'quote'
    @add.button @game.width / 2 - 38, @game.height-80, 'backButton', @goBack, @, 2, 1, 0


  #
  # Phaser.State::update
  #
  # @return	Nothing
  #
  goBack: () ->
    @state.start 'Intro', true, false
