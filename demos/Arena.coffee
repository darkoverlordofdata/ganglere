#+--------------------------------------------------------------------+
#| Arena.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Ganglere
#|
#| Ganglere is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Ganglere - The Deluding of Gylfe
#
# Arena - Lair of Fenris
#
"use strict"

ganglere = require("../ganglere")

# ----------------------------
# Arena - Lair of Fenris
# ----------------------------
class ganglere.Arena extends Phaser.State
  
  hud         : null
  map         : null
  clickeable  : true

  #
  # Phaser.State::create
  #
  # @return	Nothing
  #
  create: =>
    @game.stage.backgroundColor = "#2e203c"
    @cursors = game.input.keyboard.createCursorKeys()
    @hud = new ganglere.HUD(this)
    @mapData = ganglere.Map.generateMap("ROTmap", @cache, ganglere.COLS, ganglere.ROWS, 32, 32)
    map = @add.tilemap("ROTmap")
    map.addTilesetImage "forest-tiles", "forest-tiles"
    layer1 = map.createLayer("ground")
    layer1.resizeWorld()
    layer2 = map.createLayer("decoration")
    layer2.resizeWorld()
    @input.onDown.add @onKeyUp, @
    @input.setMoveCallback @mouseCallback, @
    @map = new ganglere.Map(@mapData, map)
    @initActors()
    @map.light()
    style =
      font: "16px monospace"
      fill: "#fff"

    ganglere.playerHUD = @add.text(0, 0, "Player life: " + ganglere.actorList[0].hp, style)
    ganglere.playerHUD.fixedToCamera = true
    ganglere.playerHUD.cameraOffset.setTo 500, 50
    return

  #
  # Mouse Callback
  #
  # @return	Nothing
  #
  mouseCallback: =>
    if @clickeable and @input.activePointer.isDown
      @clickeable = false
      setTimeout (g) ->
        g.clickeable = true
        return
      , 400, this
      x = @input.activePointer.worldX
      y = @input.activePointer.worldY
      dx = Math.abs(ganglere.player.sprite.x - x)
      dy = Math.abs(ganglere.player.sprite.y - y)
      if dx > dy
        if x > ganglere.player.sprite.x
          @onKeyUp keyCode: Phaser.Keyboard.RIGHT
        else
          @onKeyUp keyCode: Phaser.Keyboard.LEFT
      else
        if y > ganglere.player.sprite.y
          @onKeyUp keyCode: Phaser.Keyboard.DOWN
        else
          @onKeyUp keyCode: Phaser.Keyboard.UP
    return

  #
  # On Key Up
  #
  # @param  [Event]  event
  # @return	Nothing
  #
  onKeyUp: (event) =>
    return  unless ganglere.actorList[0].isPlayer
    
    switch event.keyCode
    
      when Phaser.Keyboard.LEFT
        acted = @moveTo(ganglere.player, x: -1, y: 0)
      
      when Phaser.Keyboard.RIGHT
        acted = @moveTo(ganglere.player, x: 1, y: 0)
      
      when Phaser.Keyboard.UP
        acted = @moveTo(ganglere.player, x: 0, y: -1)
      
      when Phaser.Keyboard.DOWN
        acted = @moveTo(ganglere.player, x: 0, y: 1)
        
      else acted = false
      
    if acted
      @map.computeLight()
      enemy = undefined
      i = 1

      while i < ganglere.actorList.length
        enemy = ganglere.actorList[i]
        @aiAct enemy
        i++
    return

  #
  # Move To
  #
  # @param  [ganglere.Actor]  actor
  # @param  [Number]  direction
  # @return	true
  #
  moveTo: (actor, dir) =>
    
    # check if actor can move in the given direction
    return false  unless @map.canGo(actor, dir)
    if dir.x is 1
      actor.sprite.frame = 2
    else if dir.x is -1
      actor.sprite.frame = 3
    else if dir.y is -1
      actor.sprite.frame = 1
    else actor.sprite.frame = 0  if dir.y is 1
    
    # moves actor to the new location
    newKey = (actor.x + dir.x) + "_" + (actor.y + dir.y)
    
    # if the destination tile has an actor in it
    if ganglere.actorMap.hasOwnProperty(newKey) and ganglere.actorMap[newKey]
      
      #decrement hitpoints of the actor at the destination tile
      victim = ganglere.actorMap[newKey]
      
      # avoid orcs to fight with each other
      return  if not actor.isPlayer and not victim.isPlayer
      damage = @diceRoll("d8+2").total
      victim.hp -= damage
      axis = (if (actor.x is victim.x) then "y" else "x")
      dir = victim[axis] - actor[axis]
      dir = dir / Math.abs(dir) # +1 or -1
      pos1 = {}
      pos2 = {}
      pos1[axis] = (dir * 15).toString()
      pos2[axis] = (dir * 15 * (-1)).toString()
      game.camera.follow false
      game.add.tween(actor.sprite)
      .to(pos1, 100, Phaser.Easing.Linear.None, true)
      .to(pos2, 100, Phaser.Easing.Linear.None, true)
      .onComplete.add ->
        game.camera.follow actor.sprite
        return
      , this
      color = (if victim.isPlayer then null else "#fff")
      @hud.msg damage.toString(), victim.sprite, 450, color
      ganglere.playerHUD.setText "Player life: " + victim.hp  if victim.isPlayer
      
      # if it's dead remove its reference
      if victim.hp <= 0
        victim.sprite.kill()
        delete ganglere.actorMap[newKey]

        ganglere.actorList.splice ganglere.actorList.indexOf(victim), 1
        if victim isnt ganglere.player
          if ganglere.actorList.length is 1
            
            # victory message
            victory = game.add.text(game.world.centerX, game.world.centerY, "Victory!\nCtrl+r to restart",
              fill: "#2e2"
              align: "center"
            )
            victory.anchor.setTo 0.5, 0.5
    else
      
      # remove reference to the actor's old position
      delete ganglere.actorMap[actor.x + "_" + actor.y]

      
      # update position
      actor.setXY actor.x + dir.x, actor.y + dir.y
      
      # add reference to the actor's new position
      ganglere.actorMap[actor.x + "_" + actor.y] = actor
    true
    
  #
  # Initialize Actors
  #
  # @return	Nothing
  #
  initActors: () =>
    
    # create actors at random locations
    ganglere.actorList = []
    ganglere.actorMap = {}
    actor = undefined
    x = undefined
    y = undefined
    random = (max) ->
      Math.floor Math.random() * max

    validpos = []
    x = 0
    while x < ganglere.COLS
      y = 0
      while y < ganglere.ROWS
        unless @map.tiles[x][y]
          validpos.push
            x: x
            y: y

        y++
      x++
    e = 0

    while e < ganglere.ACTORS
      
      # create new actor
      loop
        
        #var room=m.rooms[random(2)][random(2)];
        r = validpos[random(validpos.length)]
        x = r.x
        y = r.y
        
        # pick a random position that is both a floor and not occupied
        #x=room.x+random(room.width);
        #y=room.y+random(room.height);
        break unless ganglere.actorMap[x + "_" + y]
      actor = (if (e is 0) then new ganglere.Player(this, x, y) else new ganglere.Enemy(this, x, y))
      
      # add references to the actor to the actors list & map
      ganglere.actorMap[actor.x + "_" + actor.y] = actor
      ganglere.actorList.push actor
      e++
    
    # the ganglere.player is the first actor in the list
    ganglere.player = ganglere.actorList[0]
    @camera.follow ganglere.player.sprite
    return
    
  #
  # A I Act
  #
  # @param  [ganglere.Actor]  actor
  # @return	Nothing
  #
  aiAct: (actor) =>
    directions = [
      {
        x: -1
        y: 0
      }
      {
        x: 1
        y: 0
      }
      {
        x: 0
        y: -1
      }
      {
        x: 0
        y: 1
      }
    ]
    dx = ganglere.player.x - actor.x
    dy = ganglere.player.y - actor.y
    @moveToRandomPos = =>
      rndDirections = @shuffleArray(directions)
      i = 0

      while i < rndDirections.length
        break  if @moveTo(actor, rndDirections[i])
        i++
      return

    
    # if ganglere.player is far away, walk randomly
    if Math.abs(dx) + Math.abs(dy) > 6
      @moveToRandomPos()
    else
      # otherwise walk towards ganglere.player
      directions = directions.map((e) ->
        x: e.x
        y: e.y
        dist: Math.pow(dx + e.x, 2) + Math.pow(dy + e.y, 2)
      ).sort((a, b) ->
        b.dist - a.dist
      )
      d = 0
      len = directions.length

      while d < len
        break  if @moveTo(actor, directions[d])
        d++
    if ganglere.player.hp < 1

#      @game.state.start 'GameOver', true, false
      
      # game over message
      gameOver = game.add.text(0, 0, "Game Over\nCtrl+r to restart",
        fill: "#e22"
        align: "center"
      )
      gameOver.fixedToCamera = true
      gameOver.cameraOffset.setTo 0, 0
    return
    
  #
  # Fisher-Yates shuffle algorithm
  #
  # @param  [Array]  array
  # @return	the shuffled array
  #
  shuffleArray: (array) ->
  
    i = array.length
    while --i > 0
      j = ~~(Math.random() * (i + 1))
      t = array[j]
      array[j] = array[i]
      array[i] = t
    array
  

  #
  # Dice Roll
  #
  # @param  [String]  data
  # @return	object
  #
  diceRoll: (data) ->
    
    # data val sample '1d8+12'
    # data val sample '4d8-10'
    # data val sample 'd8+2'
    data = " " + data
    dataSplit = data.split(/-|\+|d/g)
    dices = parseInt(dataSplit[0], 10)
    dices = 1  unless dices
    sides = parseInt(dataSplit[1], 10)
    ret =
      diceRoll: []
      number: 0
      bonus: 0

    ret.number = 0
    n = undefined
    i = 0

    while i < dices
      n = 1 + Math.floor(Math.random() * sides)
      ret.diceRoll.push n
      ret.number += n
      i++
    if dataSplit[2]
      ret.bonus = parseInt(dataSplit[2], 10)
      ret.bonus = ret.bonus * -1  if data.indexOf("-") > -1
    ret.total = ret.number + ret.bonus
    ret
    

