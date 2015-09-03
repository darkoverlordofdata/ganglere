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

# Define our help screen
Game.Screen.helpScreen =
  render: (display) ->
    text = "jsrogue help"
    border = "-------------"
    y = 0
    display.drawText Game.getScreenWidth() / 2 - text.length / 2, y++, text
    display.drawText Game.getScreenWidth() / 2 - text.length / 2, y++, border
    display.drawText 0, y++, "The villagers have been complaining of a terrible stench coming from the cave."
    display.drawText 0, y++, "Find the source of this smell and get rid of it!"
    y += 3
    display.drawText 0, y++, "[,] to pick up items"
    display.drawText 0, y++, "[d] to drop items"
    display.drawText 0, y++, "[e] to eat items"
    display.drawText 0, y++, "[w] to wield items"
    display.drawText 0, y++, "[W] to wield items"
    display.drawText 0, y++, "[x] to examine items"
    display.drawText 0, y++, "[;] to look around you"
    display.drawText 0, y++, "[?] to show this help screen"
    y += 3
    text = "--- press any key to continue ---"
    display.drawText Game.getScreenWidth() / 2 - text.length / 2, y++, text

  handleInput: (inputType, inputData) ->
    Game.Screen.playScreen.setSubScreen null
