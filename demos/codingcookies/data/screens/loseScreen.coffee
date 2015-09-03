#+--------------------------------------------------------------------+
#| loseScreen.coffee
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


# Define our winning screen
Game.Screen.loseScreen =
  enter: ->
    console.log "Entered lose screen."

  exit: ->
    console.log "Exited lose screen."

  render: (display) ->
    
    # Render our prompt to the screen
    i = 0

    while i < 22
      display.drawText 2, i + 1, "%b{red}You lose! :("
      i++

  handleInput: (inputType, inputData) ->


