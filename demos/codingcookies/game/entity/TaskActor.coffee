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

Game.EntityMixins.TaskActor =
  name: "TaskActor"
  groupName: "Actor"
  init: (template) ->
    
    # Load tasks
    @_tasks = template["tasks"] or ["wander"]

  act: ->
    
    # Iterate through all our tasks
    i = 0

    while i < @_tasks.length
      if @canDoTask(@_tasks[i])
        
        # If we can perform the task, execute the function for it.
        this[@_tasks[i]]()
        return
      i++

  canDoTask: (task) ->
    if task is "hunt"
      @hasMixin("Sight") and @canSee(@getMap().getPlayer())
    else if task is "wander"
      true
    else
      throw new Error("Tried to perform undefined task " + task)

  hunt: ->
    player = @getMap().getPlayer()
    
    # If we are adjacent to the player, then attack instead of hunting.
    offsets = Math.abs(player.getX() - @getX()) + Math.abs(player.getY() - @getY())
    if offsets is 1
      if @hasMixin("Attacker")
        @attack player
        return
    
    # Generate the path and move to the first tile.
    source = this
    z = source.getZ()
    path = new ROT.Path.AStar(player.getX(), player.getY(), (x, y) ->
      
      # If an entity is present at the tile, can't move there.
      entity = source.getMap().getEntityAt(x, y, z)
      return false  if entity and entity isnt player and entity isnt source
      source.getMap().getTile(x, y, z).isWalkable()
    ,
      topology: 4
    )
    
    # Once we've gotten the path, we want to move to the second cell that is
    # passed in the callback (the first is the entity's strting point)
    count = 0
    path.compute source.getX(), source.getY(), (x, y) ->
      source.tryMove x, y, z  if count is 1
      count++


  wander: ->
    
    # Flip coin to determine if moving by 1 in the positive or negative direction
    moveOffset = (if (Math.round(Math.random()) is 1) then 1 else -1)
    
    # Flip coin to determine if moving in x direction or y direction
    if Math.round(Math.random()) is 1
      @tryMove @getX() + moveOffset, @getY(), @getZ()
    else
      @tryMove @getX(), @getY() + moveOffset, @getZ()

