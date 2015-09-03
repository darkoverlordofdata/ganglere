#+--------------------------------------------------------------------+
#| glyph.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#|  ______
#|  | ___ \
#|  | |_/ /___   __ _ _   _  ___ _ __
#|  |    // _ \ / _` | | | |/ _ \ '__|
#|  | |\ \ (_) | (_| | |_| |  __/ |
#|  \_| \_\___/ \__, |\__,_|\___|_| a rogue like game
#|               __/ |
#|              |___/
#|
#| Roguer is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Define the basic glyph object
#

Game = require('./../game')

class Game.Glyph

  constructor: (properties) ->
  
    # Instantiate properties to default if they weren't passed
    properties = properties or {}
    @_char = properties["character"] or " "
    @_foreground = properties["foreground"] or "white"
    @_background = properties["background"] or "black"


  # Create standard getters for glyphs
  getChar: ->
    @_char

  getBackground: ->
    @_background

  getForeground: ->
    @_foreground

  getRepresentation: ->
    "%c{" + @_foreground + "}%b{" + @_background + "}" + @_char + "%c{white}%b{black}"
