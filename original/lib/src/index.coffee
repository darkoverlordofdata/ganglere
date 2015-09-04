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
"use strict"
window.game = null
ganglere = require('./ganglere')
window.addEventListener 'load',  ->
  FastClick?.attach document.body
  setTimeout () ->
    #
    # Replace brand logo with product splash
    #
    document.getElementById("logo").style.display = 'none'
    document.getElementById("title").style.display = 'none'
    document.body.style.backgroundColor = 'black'
    new ganglere('game')
  ,1000
, false
