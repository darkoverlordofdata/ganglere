#+--------------------------------------------------------------------+
#| entitymixins.coffee
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
# Define mixins
#

Game = require('./../../game')

Game.EntityMixins.FoodConsumer =
  name: "FoodConsumer"
  init: (template) ->
    @_maxFullness = template["maxFullness"] or 1000
    
    # Start halfway to max fullness if no default value
    @_fullness = template["fullness"] or (@_maxFullness / 2)
    
    # Number of points to decrease fullness by every turn.
    @_fullnessDepletionRate = template["fullnessDepletionRate"] or 1

  addTurnHunger: ->
    
    # Remove the standard depletion points
    @modifyFullnessBy -@_fullnessDepletionRate

  modifyFullnessBy: (points) ->
    @_fullness = @_fullness + points
    if @_fullness <= 0
      @kill "You have died of starvation!"
    else @kill "You choke and die!"  if @_fullness > @_maxFullness

  getHungerState: ->
    
    # Fullness points per percent of max fullness
    perPercent = @_maxFullness / 100
    
    # 5% of max fullness or less = starving
    if @_fullness <= perPercent * 5
      "Starving"
    
    # 25% of max fullness or less = hungry
    else if @_fullness <= perPercent * 25
      "Hungry"
    
    # 95% of max fullness or more = oversatiated
    else if @_fullness >= perPercent * 95
      "Oversatiated"
    
    # 75% of max fullness or more = full
    else if @_fullness >= perPercent * 75
      "Full"
    
    # Anything else = not hungry
    else
      "Not Hungry"

