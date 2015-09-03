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

Game.EntityMixins.ExperienceGainer =
  name: "ExperienceGainer"
  init: (template) ->
    @_level = template["level"] or 1
    @_experience = template["experience"] or 0
    @_statPointsPerLevel = template["statPointsPerLevel"] or 1
    @_statPoints = 0
    
    # Determine what stats can be levelled up.
    @_statOptions = []
    if @hasMixin("Attacker")
      @_statOptions.push [
        "Increase attack value"
        this.increaseAttackValue
      ]
    if @hasMixin("Destructible")
      @_statOptions.push [
        "Increase defense value"
        this.increaseDefenseValue
      ]
      @_statOptions.push [
        "Increase max health"
        this.increaseMaxHp
      ]
    if @hasMixin("Sight")
      @_statOptions.push [
        "Increase sight range"
        this.increaseSightRadius
      ]

  getLevel: ->
    @_level

  getExperience: ->
    @_experience

  getNextLevelExperience: ->
    (@_level * @_level) * 10

  getStatPoints: ->
    @_statPoints

  setStatPoints: (statPoints) ->
    @_statPoints = statPoints

  getStatOptions: ->
    @_statOptions

  giveExperience: (points) ->
    statPointsGained = 0
    levelsGained = 0
    
    # Loop until we've allocated all points.
    while points > 0
      
      # Check if adding in the points will surpass the level threshold.
      if @_experience + points >= @getNextLevelExperience()
        
        # Fill our experience till the next threshold.
        usedPoints = @getNextLevelExperience() - @_experience
        points -= usedPoints
        @_experience += usedPoints
        
        # Level up our entity!
        @_level++
        levelsGained++
        @_statPoints += @_statPointsPerLevel
        statPointsGained += @_statPointsPerLevel
      else
        
        # Simple case - just give the experience.
        @_experience += points
        points = 0
    
    # Check if we gained at least one level.
    if levelsGained > 0
      Game.sendMessage this, "You advance to level %d.", [@_level]
      @raiseEvent "onGainLevel"

  listeners:
    onKill: (victim) ->
      exp = victim.getMaxHp() + victim.getDefenseValue()
      exp += victim.getAttackValue()  if victim.hasMixin("Attacker")
      
      # Account for level differences
      exp -= (@getLevel() - victim.getLevel()) * 3  if victim.hasMixin("ExperienceGainer")
      
      # Only give experience if more than 0.
      @giveExperience exp  if exp > 0

    details: ->
      [
        key: "level"
        value: @getLevel()
      ]

