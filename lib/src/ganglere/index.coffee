#+--------------------------------------------------------------------+
#| index.coffee
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
# Game namespace
#
"use strict"

module.exports = 
class ganglere extends Phaser.Game

  id          : ''
  width       : 320
  height      : 480
  renderer    : Phaser.AUTO
  
  #
  # Create the game
  #
  # @paran [String] dom id
  # @return	this
  #
  constructor: (@id) ->

    super @width, @height, @renderer, @id

    @state.add 'Initialize',  ganglere.Initialize, false
    @state.add 'Assets',      ganglere.Assets, false
    @state.add 'Intro',       ganglere.Intro, false
    @state.add 'Credits',     ganglere.Credits, false
    @state.add 'Scores',      ganglere.Scores, false
    @state.add 'Levels',      ganglere.Levels, false
    @state.add 'GameOver',    ganglere.GameOver, false

    @state.start 'Initialize'


require './Config'
require './Random'
require './AI'
require './Actor'
require './Player'
require './Enemy'
require './Map'
require './Assets'
require './Initialize'
require './Intro'
require './Credits'
require './Scores'
require './Levels'
require './GameOver'
