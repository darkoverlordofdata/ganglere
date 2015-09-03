#+--------------------------------------------------------------------+
#| itemmixins.coffee
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

Game.ItemMixins.Edible =
  name: "Edible"
  init: (template) ->

    # Number of points to add to hunger
    @_foodValue = template["foodValue"] or 5

    # Number of times the item can be consumed
    @_maxConsumptions = template["consumptions"] or 1
    @_remainingConsumptions = @_maxConsumptions

  eat: (entity) ->
    if entity.hasMixin("FoodConsumer")
      if @hasRemainingConsumptions()
        entity.modifyFullnessBy @_foodValue
        @_remainingConsumptions--

  hasRemainingConsumptions: ->
    @_remainingConsumptions > 0

  describe: ->
    unless @_maxConsumptions is @_remainingConsumptions
      "partly eaten " + Game.Item::describe.call(this)
    else
      @_name

  listeners:
    details: ->
      [
        key: "food"
        value: @_foodValue
      ]

