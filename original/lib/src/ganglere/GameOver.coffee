#+--------------------------------------------------------------------+
#| GameOver.coffee
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
# Levels - Lair of Fenris
#
"use strict"

ganglere = require("../ganglere")

# ----------------------------
# GameOver
# ----------------------------
class ganglere.GameOver extends Phaser.State

  #
  # Phaser.State::create
  #
  # @return	Nothing
  #
  create: =>
  
    # game over message
    gameOver = @add.text(0, 0, "Game Over\nCtrl+r to restart",
      fill: "#e22"
      align: "center"
    )
    gameOver.fixedToCamera = true
    gameOver.cameraOffset.setTo 0,0 # 500, 500
