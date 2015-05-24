#+--------------------------------------------------------------------+
#| Initialize.coffee
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
# Initialize
#
#   Start loading the the splash screen image
#   Set the screen parameters
#
"use strict"

ganglere = require('../ganglere')

# ----------------------------
# Initialize
# ----------------------------
class ganglere.Initialize extends Phaser.State

  # Here we've just got some global level vars that persist regardless of State swaps
  @score = 0

  # If the music in your game needs to play through-out a few State swaps, then you could reference it here
  @music = null

  # Your game can check BasicGame.orientated in internal loops to know if it should pause or not
  @orientated = false


  #
  # Phaser.State::create
  #
  # @return	Nothing
  #
  preload: () ->

      @load.image 'splash', 'assets/images/splash.png'
      @load.image 'preloaderBackground', 'assets/images/progress_bar_background.png'
      @load.image 'preloaderBar', 'assets/images/progress_bar.png'


  #
  # Phaser.State::create
  #
  # @return	Nothing
  #
  create: () ->

    @input.maxPointers = 1
    @stage.disableVisibilityChange = true

    if @game.device.desktop
      @scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
      @scale.minWidth = 320
      @scale.minHeight = 480
      @scale.maxWidth = 640
      @scale.maxHeight = 960
      @scale.pageAlignHorizontally = true
      @scale.pageAlignVertically = true
      @scale.setScreenSize true
    
    else
      @scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
      @scale.minWidth = 320
      @scale.minHeight = 480
      @scale.maxWidth = 640
      @scale.maxHeight = 960
      @scale.pageAlignHorizontally = true
      @scale.pageAlignVertically = true
      @scale.forceOrientation false
      @scale.hasResized.add @gameResized, @
      @scale.enterIncorrectOrientation.add @enterIncorrectOrientation, @
      @scale.leaveIncorrectOrientation.add @leaveIncorrectOrientation, @
      @scale.setScreenSize true

    # Load the remaining assets
    @state.start 'Assets', true, false

  gameResized: (width, height) ->


  enterIncorrectOrientation: () ->

    Ganglere.orientated = false
    document.getElementById('orientation').style.display = 'block'

  leaveIncorrectOrientation: () ->

    Ganglere.orientated = true
    document.getElementById('orientation').style.display = 'none'

