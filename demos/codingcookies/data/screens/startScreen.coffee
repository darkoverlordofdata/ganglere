#+--------------------------------------------------------------------+
#| startScreen.coffee
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
# Define screens
#

Game = require('./../../game')

Game.Screen = {} unless Game.Screen?

# Define our initial start screen
Game.Screen.startScreen =
  enter: ->
    console.log "Entered start screen."

  exit: ->
    console.log "Exited start screen."

  render: (display) ->
    
    # Render our prompt to the screen
    display.drawText 1, 1, "%c{yellow}Javascript Roguelike"
    display.drawText 1, 2, "Press [Enter] to start!"

  handleInput: (inputType, inputData) ->
    
    # When [Enter] is pressed, go to the play screen
    Game.switchScreen Game.Screen.playScreen  if inputData.keyCode is ROT.VK_RETURN  if inputType is "keydown"


