#+--------------------------------------------------------------------+
#| Credits.coffee
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
# Credits:
#
# Myth: <a href="http://www.gutenberg.org/files/18947/18947-h/18947-h.htm#gylfe_I">The Fooling of Gylfe by Snorre Sturluson</a>
# Phaser.io
# vellum toned paper texture by http://sporkystock.deviantart.com/
# font Eagle Lake by <a href="">Astigmatic</a>
#
"use strict"

ganglere = require('../ganglere')


# ----------------------------
# Display the credits
# ----------------------------
class ganglere.Credits extends Phaser.State


  text: """
Program by darkoverlordofdata

Sprites by Svetlana Kushnariova
  lana-chan@yandex.ru

Web font Eagle Lake by astigmatic

Vellum toned paper texture by sporkystock
  """
  
  copyright: """
Copyright 2014 Dark Overlord of Data
  """
  
  quoteStyle:
    font    : "italic 14px Arial"
    fill    : '#000'
    align   : 'center' 

  style:
    font    : "14px Arial"
    fill    : '#000'
    align   : 'center' 
    
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
    @add.text 10, 150, @text, @style
    @add.button @game.width / 2 - 38, @game.height-80, 'backButton', @goBack, @, 2, 1, 0
    @add.text 50, @game.height-40, @copyright, @style

  #
  # Phaser.State::update
  #
  # @return	Nothing
  #
  goBack: () ->
    @state.start 'Intro', true, false
