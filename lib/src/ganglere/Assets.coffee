#+--------------------------------------------------------------------+
#| Assets.coffee
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
# Load the game assets
#
"use strict"

ganglere = require('../ganglere')


# ----------------------------
# Load the game assets
# ----------------------------
class ganglere.Assets extends Phaser.State

  splashScreen: Phaser.Sprite
  
  constructor: ->
		@background = null
		@preloadBar = null
		@preloadBgd = null
		@ready = false

  #
  # Phaser.State::preload
  #
  # @return	Nothing
  #
  preload: () ->

    #  Splash...
    @add.sprite(0, 0, 'splash')
    @preloadBgd = @add.sprite(@game.width / 2 - 250, @game.height - 100, 'preloaderBackground')
    @preloadBar = @add.sprite(@game.width / 2 - 250, @game.height - 100, 'preloaderBar')
    @load.setPreloadSprite @preloadBar
    
    #
    # load ui features
    #
    @load.image 'background', 'assets/images/background.png'
    @load.image 'backButton',  'assets/images/buttons/back1.png'
    @load.image 'playButton',  'assets/images/buttons/play1.png'
    @load.image 'scoreButton',  'assets/images/buttons/score1.png'
    @load.image 'creditsButton',  'assets/images/buttons/credits1.png'
    
    @load.image 'quote', 'assets/images/quote.png'
    @load.image 'icon', 'assets/images/icon.png'

#
    # load level tilesets
    #
    for key, level of ganglere.config.levels
    
      @load.json "#{level.options.map}.json",  "assets/levels/#{level.options.map}.json"
    
    
    #
    # load sprite images
    #
    for key, sprite of ganglere.config.sprites
    
      if 'string' is typeof sprite.file
        @load.spritesheet key, sprite.file, sprite.width, sprite.height
      else
        if sprite.selected? 
          @load.spritesheet key, sprite.file[sprite.selected], sprite.width, sprite.height
        for file, ix in sprite.file
          @load.spritesheet "#{key}[#{ix}]", file, sprite.width, sprite.height

  #
  # Phaser.State::create
  #
  # @return	Nothing
  #
  create: () ->
    @preloadBar.cropEnabled = false
      
  #
  # Phaser.State::update
  #
  # @return	Nothing
  #
  update: () ->
    @state.start 'Intro', true, false, level: 0
