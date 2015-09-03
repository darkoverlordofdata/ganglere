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

Game.EntityMixins.GiantZombieActor = Game.merge(Game.EntityMixins.TaskActor,
  init: (template) ->

    # Call the task actor init with the right tasks.
    Game.EntityMixins.TaskActor.init.call this, Game.merge(template,
      tasks: [
        "growArm"
        "spawnSlime"
        "hunt"
        "wander"
      ]
    )

    # We only want to grow the arm once.
    @_hasGrownArm = false

  canDoTask: (task) ->

    # If we haven't already grown arm and HP <= 20, then we can grow.
    if task is "growArm"
      @getHp() <= 20 and not @_hasGrownArm

    # Spawn a slime only a 10% of turns.
    else if task is "spawnSlime"
      Math.round(Math.random() * 100) <= 10

    # Call parent canDoTask
    else
      Game.EntityMixins.TaskActor.canDoTask.call this, task

  growArm: ->
    @_hasGrownArm = true
    @increaseAttackValue 5

    # Send a message saying the zombie grew an arm.
    Game.sendMessageNearby @getMap(), @getX(), @getY(), @getZ(), "An extra arm appears on the giant zombie!"

  spawnSlime: ->

    # Generate a random position nearby.
    xOffset = Math.floor(Math.random() * 3) - 1
    yOffset = Math.floor(Math.random() * 3) - 1

    # Check if we can spawn an entity at that position.

    # If we cant, do nothing
    return  unless @getMap().isEmptyFloor(@getX() + xOffset, @getY() + yOffset, @getZ())

    # Create the entity
    slime = Game.EntityRepository.create("slime")
    slime.setX @getX() + xOffset
    slime.setY @getY() + yOffset
    slime.setZ @getZ()
    @getMap().addEntity slime

  listeners:
    onDeath: (attacker) ->

      # Switch to win screen when killed!
      Game.switchScreen Game.Screen.winScreen
)

