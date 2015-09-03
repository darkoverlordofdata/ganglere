#+--------------------------------------------------------------------+
#| screens.coffee
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

Game.Screen.gainStatScreen =
  setup: (entity) ->
    
    # Must be called before rendering.
    @_entity = entity
    @_options = entity.getStatOptions()

  render: (display) ->
    letters = "abcdefghijklmnopqrstuvwxyz"
    display.drawText 0, 0, "Choose a stat to increase: "
    
    # Iterate through each of our options
    i = 0

    while i < @_options.length
      display.drawText 0, 2 + i, letters.substring(i, i + 1) + " - " + @_options[i][0]
      i++
    
    # Render remaining stat points
    display.drawText 0, 4 + @_options.length, "Remaining points: " + @_entity.getStatPoints()

  handleInput: (inputType, inputData) ->
    if inputType is "keydown"
      
      # If a letter was pressed, check if it matches to a valid option.
      if inputData.keyCode >= ROT.VK_A and inputData.keyCode <= ROT.VK_Z
        
        # Check if it maps to a valid item by subtracting 'a' from the character
        # to know what letter of the alphabet we used.
        index = inputData.keyCode - ROT.VK_A
        if @_options[index]
          
          # Call the stat increasing function
          @_options[index][1].call @_entity
          
          # Decrease stat points
          @_entity.setStatPoints @_entity.getStatPoints() - 1
          
          # If we have no stat points left, exit the screen, else refresh
          if @_entity.getStatPoints() is 0
            Game.Screen.playScreen.setSubScreen `undefined`
          else
            Game.refresh()

