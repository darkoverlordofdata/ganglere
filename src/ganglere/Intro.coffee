#+--------------------------------------------------------------------+
#| Intro.coffee
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
# Intro Screen
#
"use strict"

ganglere = require('../ganglere')


# ----------------------------
# Display start buttons
# ----------------------------
class ganglere.Intro extends Phaser.State


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
    @add.sprite 0, 0, 'splash'
    @add.button 100, 270, 'playButton', @startGame, @, 2, 1, 0
    @add.button 100, 310, 'creditsButton', @showCredits, @, 2, 1, 0
    @add.button 100, 350, 'scoreButton', @showScores, @, 2, 1, 0


  #
  # Show Credits
  #
  # @return	Nothing
  #
  showCredits: () ->
    @state.start 'Credits', true, false

  #
  # Show Scores
  #
  # @return	Nothing
  #
  showScores: () ->
    @state.start 'Scores', true, false

  #
  # Start Game
  #
  # @return	Nothing
  #
  startGame: () ->
    @state.start 'Levels', true, false, level: 0

