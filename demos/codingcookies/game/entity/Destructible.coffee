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


# This mixin signifies an entity can take damage and be destroyed
Game.EntityMixins.Destructible =
  name: "Destructible"
  init: (template) ->
    @_maxHp = template["maxHp"] or 10
    
    # We allow taking in health from the template incase we want
    # the entity to start with a different amount of HP than the 
    # max specified.
    @_hp = template["hp"] or @_maxHp
    @_defenseValue = template["defenseValue"] or 0

  getDefenseValue: ->
    modifier = 0
    
    # If we can equip items, then have to take into 
    # consideration weapon and armor
    if @hasMixin(Game.EntityMixins.Equipper)
      modifier += @getWeapon().getDefenseValue()  if @getWeapon()
      modifier += @getArmor().getDefenseValue()  if @getArmor()
    @_defenseValue + modifier

  getHp: ->
    @_hp

  getMaxHp: ->
    @_maxHp

  setHp: (hp) ->
    @_hp = hp

  increaseDefenseValue: (value) ->
    
    # If no value was passed, default to 2.
    value = value or 2
    
    # Add to the defense value.
    @_defenseValue += value
    Game.sendMessage this, "You look tougher!"

  increaseMaxHp: (value) ->
    
    # If no value was passed, default to 10.
    value = value or 10
    
    # Add to both max HP and HP.
    @_maxHp += value
    @_hp += value
    Game.sendMessage this, "You look healthier!"

  takeDamage: (attacker, damage) ->
    @_hp -= damage
    
    # If have 0 or less HP, then remove ourseles from the map
    if @_hp <= 0
      Game.sendMessage attacker, "You kill the %s!", [@getName()]
      
      # Raise events
      @raiseEvent "onDeath", attacker
      attacker.raiseEvent "onKill", this
      @kill()

  listeners:
    onGainLevel: ->
      
      # Heal the entity.
      @setHp @getMaxHp()

    details: ->
      [
        {
          key: "defense"
          value: @getDefenseValue()
        }
        {
          key: "hp"
          value: @getHp()
        }
      ]

