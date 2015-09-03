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

Game.EntityMixins.Equipper =
  name: "Equipper"
  init: (template) ->
    @_weapon = null
    @_armor = null

  wield: (item) ->
    @_weapon = item

  unwield: ->
    @_weapon = null

  wear: (item) ->
    @_armor = item

  takeOff: ->
    @_armor = null

  getWeapon: ->
    @_weapon

  getArmor: ->
    @_armor

  unequip: (item) ->
    
    # Helper function to be called before getting rid of an item.
    @unwield()  if @_weapon is item
    @takeOff()  if @_armor is item

