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


# This signifies our entity can attack basic destructible enities
Game.EntityMixins.Attacker =
  name: "Attacker"
  groupName: "Attacker"
  init: (template) ->
    @_attackValue = template["attackValue"] or 1

  getAttackValue: ->
    modifier = 0
    
    # If we can equip items, then have to take into 
    # consideration weapon and armor
    if @hasMixin(Game.EntityMixins.Equipper)
      modifier += @getWeapon().getAttackValue()  if @getWeapon()
      modifier += @getArmor().getAttackValue()  if @getArmor()
    @_attackValue + modifier

  increaseAttackValue: (value) ->
    
    # If no value was passed, default to 2.
    value = value or 2
    
    # Add to the attack value.
    @_attackValue += value
    Game.sendMessage this, "You look stronger!"

  attack: (target) ->
    
    # If the target is destructible, calculate the damage
    # based on attack and defense value
    if target.hasMixin("Destructible")
      attack = @getAttackValue()
      defense = target.getDefenseValue()
      max = Math.max(0, attack - defense)
      damage = 1 + Math.floor(Math.random() * max)
      Game.sendMessage this, "You strike the %s for %d damage!", [
        target.getName()
        damage
      ]
      Game.sendMessage target, "The %s strikes you for %d damage!", [
        @getName()
        damage
      ]
      target.takeDamage this, damage

  listeners:
    details: ->
      [
        key: "attack"
        value: @getAttackValue()
      ]


