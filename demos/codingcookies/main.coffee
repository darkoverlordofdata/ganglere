#+--------------------------------------------------------------------+
#| main.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#|
#|       _____                   _                                                                        
#|     / ____|                 | |                                                                       
#|    | |  __  __ _ _ __   __ _| | ___ _ __ ___                                                          
#|    | | |_ |/ _` | '_ \ / _` | |/ _ \ '__/ _ \                                                         
#|    | |__| | (_| | | | | (_| | |  __/ | |  __/                                                         
#|     \_____|\__,_|_| |_|\__, |_|\___|_|  \___|                                                         
#|                         __/ |                                                                         
#|     _______ _          |___/__       _           _ _                      __    _____       _  __     
#|    |__   __| |          |  __ \     | |         | (_)                    / _|  / ____|     | |/ _|    
#|       | |  | |__   ___  | |  | | ___| |_   _  __| |_ _ __   __ _    ___ | |_  | |  __ _   _| | |_ ___ 
#|       | |  | '_ \ / _ \ | |  | |/ _ \ | | | |/ _` | | '_ \ / _` |  / _ \|  _| | | |_ | | | | |  _/ _ \
#|       | |  | | | |  __/ | |__| |  __/ | |_| | (_| | | | | | (_| | | (_) | |   | |__| | |_| | | ||  __/
#|       |_|  |_| |_|\___| |_____/ \___|_|\__,_|\__,_|_|_| |_|\__, |  \___/|_|    \_____|\__, |_|_| \___|
#|                                                             __/ |                      __/ |          
#|                                                            |___/                      |___/           
#|
#|
#| Ganglere - The Deluding of Gylfe
#| is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Load the game when the browser is ready
#

window.onload = ->

  # Check if rot.js can work on this browser
  if ROT.isSupported()

    # Initialize the game
    Game = require('./game')
    Game.init()

    # Add the container to our HTML page
    document.body.appendChild Game.getDisplay().getContainer()

    # Load the start screen
    Game.switchScreen Game.Screen.startScreen

  else
    alert "The rot.js library isn't supported by your browser."

  return