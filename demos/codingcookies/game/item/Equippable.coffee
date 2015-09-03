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

Game.ItemMixins.Equippable =
  name: "Equippable"
  init: (template) ->
    @_attackValue = template["attackValue"] or 0
    @_defenseValue = template["defenseValue"] or 0
    @_wieldable = template["wieldable"] or false
    @_wearable = template["wearable"] or false

  getAttackValue: ->
    @_attackValue

  getDefenseValue: ->
    @_defenseValue

  isWieldable: ->
    @_wieldable

  isWearable: ->
    @_wearable

  listeners:
    details: ->
      results = []
      if @_wieldable
        results.push
          key: "attack"
          value: @getAttackValue()

      if @_wearable
        results.push
          key: "defense"
          value: @getDefenseValue()

      results
