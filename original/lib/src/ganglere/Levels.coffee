#+--------------------------------------------------------------------+
#| Levels.coffee
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
# Level Manager
#
#   inspired by https://github.com/eugenioclrc/roguelike-js
#
#
"use strict"

ganglere = require("../ganglere")

# ----------------------------
# Levels - Level Manager
# ----------------------------
class ganglere.Levels extends Phaser.State

  WHITE       = '#fff'      # Enemy damage pts
  BLACK       = '#000'
  HUNTER      = '#ff0044'   # Player damage pts

  automove    : true  
  inmotion    : false
  actorList   : null        # list of all the actors
  actorMap    : null        # map of actors by position
  player      : null        # the players actor
  options     : null        # the configuration for this level
  hud         : null        # text area for displaying hud
  map         : null        # the current dungeon map
  clickeable  : true        # ignore clicks when false
  score       : 0           # current score
  level       : 0           # current game level number
  name        : 'Splash'    # current level name
  levels      : [           # game levels in order
    'Fenris'
    'Loke'
    'Thor'
    'Game Over'
    ]
  
    
  
  #
  # Phaser.State::init
  #
  # @return	Nothing
  #
  init: (options) =>
    for key, value of options
      this[key] = value
    @name = @levels[@level]
  

    
  #
  # Phaser.State::create
  #
  # Create the new level
  #
  # @return	Nothing
  #
  create: =>
  
    @time.advancedTiming = true
        
    hudStyle =
      font    : "bold 18px monospace"
      fill    : BLACK

  
    # load the config for this level:
    for key, value of ganglere.config.levels[@name]
      console.log(key);
      console.log(value);
      this[key] = value
    
    @map = new ganglere.Map(this)
    @stage.backgroundColor = "#F0DE9C" # @map.backgroundcolor
    
    @initActors()
    @map.light()

    @hud = @add.text(0, 0, @label(@actorList[0].hp, @score, @level), hudStyle)
    @hud.fixedToCamera = true
    @hud.cameraOffset.setTo 0, @game.height-35
    
    @input.keyboard.addCallbacks null, null, @onKeyUp
    @input.onDown.add @onKeyUp, @
    @input.setMoveCallback @moveCallback, @
    
    return
    
  #
  # Move Callback
  #
  # @return	Nothing
  #
  moveCallback: =>
    if @clickeable and @input.activePointer.isDown
      @clickeable = false
      setTimeout (=> @clickeable = true), 400
      x = @input.activePointer.worldX
      y = @input.activePointer.worldY
      dx = Math.abs(@player.sprite.x - x)
      dy = Math.abs(@player.sprite.y - y)
      if dx > dy
        if x > @player.sprite.x
          @onKeyUp keyCode: Phaser.Keyboard.RIGHT
        else
          @onKeyUp keyCode: Phaser.Keyboard.LEFT
      else
        if y > @player.sprite.y
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
    return  unless @actorList[0].isPlayer
    if @doKeyUp(event)
      @map.computeLight()
      for actor in @actorList
        actor.move @player
        
        if @player.hp < 1
          # Game Over :(
          @fadeOut =>
            @state.start 'Levels', false, false, level: @levels.length, win: false
          break;

    return

  #
  # Do Key Up
  #
  # @param  [Event]  event
  # @return	true if player could move
  #
  doKeyUp: (event) =>
    switch event.keyCode
    
      when Phaser.Keyboard.LEFT
        @moveTo(@player, x: -1, y: 0)
      
      when Phaser.Keyboard.RIGHT
        @moveTo(@player, x: 1, y: 0)
      
      when Phaser.Keyboard.UP
        @moveTo(@player, x: 0, y: -1)
      
      when Phaser.Keyboard.DOWN
        @moveTo(@player, x: 0, y: 1)
        
      else false
  
  #
  # Move To
  #
  # @param  [ganglere.Actor]  actor
  # @param  [Number]  delta
  # @return	true
  #
  moveTo: (actor, delta) =>
    
    return false unless @map.isValidMove(actor, delta)
    actor.setFrame delta
    
    pos = (actor.x + delta.x) + "_" + (actor.y + delta.y)
    if @actorMap[pos]?
      
      victim = @actorMap[pos]
      
      if actor.isPlayer or victim.isPlayer
        
        actor.attack victim
        if victim.isPlayer
          @hud.setText @label(victim.hp, @score, @level)  
        else
        
          @score+=ganglere.Random.diceRoll("d2+1").total
          @hud.setText @label(@actorList[0].hp, @score, @level)  

        # if it's dead remove its reference
        if victim.hp <= 0
          victim.sprite.kill()
          delete @actorMap[pos]

          @actorList.splice @actorList.indexOf(victim), 1
          if victim isnt @player
            if @actorList.length is 1
              # Next Level?
              @level++

              if @level < @levels.length
                @fadeOut =>
                  @state.start 'Levels', true, false, level: @level

              else
                @fadeOut =>
                  @state.start 'Levels', false, false, level: @levels.length, win: true

    else
      
      # remove reference to the actor's old position
      delete @actorMap[actor.x + "_" + actor.y]
      # update position
      actor.setXY actor.x + delta.x, actor.y + delta.y
      # add reference to the actor's new position
      @actorMap[actor.x + "_" + actor.y] = actor
      
    true

  #
  # Start Game
  #
  # @return	Nothing
  #
  startGame: =>

    startGame = =>
      @state.start 'Levels', true, false, level: 1

    @time.events.add Phaser.Timer.SECOND, startGame, @
    @add.tween(@start).to(alpha: 0, 2000, Phaser.Easing.Linear.None, true)
    
  

  #
  # Label - display info
  #
  # @return	Nothing
  #
  label: (hp, score, level) =>
    """
      life:  #{hp} score: #{score} level: #{level}
    """
  #
  # Fade Out
  #
  # @param [Function] next callback to run after fade
  # @return	Nothing
  #
  fadeOut: (next) =>
  
    @time.events.add Phaser.Timer.SECOND, next, @
   
  #
  # Initialize Actors
  #
  # @return	Nothing
  #
  initActors: () =>
    
    # create actors at random locations
    @actorList = []
    @actorMap = {}
    
    random = (max) ->
      Math.floor(Math.random() * max)

    validpos = []
    for x in [0...@map.width]
      for y in [0...@map.height]
        unless @map.tiles[x][y]
          validpos.push x: x, y: y

    for a in [0...@options.actors]      
      # Find a good location
      loop
        {x,y} = validpos[random(validpos.length)]
        break unless @actorMap[x + "_" + y]
        
      actor = if a is 0 then new ganglere.Player(this, x, y) else new ganglere.Enemy(this, x, y)
      @actorMap[actor.x + "_" + actor.y] = actor
      @actorList.push actor
    
    # the @player is the first actor in the list
    @player = @actorList[0]
    @camera.follow @player.sprite
    return

  #
  # Show Damage
  #
  # @param  [String]  text
  # @param  [Phaser.Sprite] sprite
  # @param  [Number]  speed
  # @param  [String]color
  # @return	Nothing
  #
  showDamage: (text, sprite, speed, color) =>

    if navigator.notification?
      navigator.notification.vibrate(10);
      
    damageStyle = 
      align   : 'center' 
      font    : 'bold 40px Courier New, Courier'
      fill    : color

    y = sprite.y-15
    x = sprite.x+sprite.width/3
      
    text = @add.text(x, y, text, damageStyle)

    @add.tween(text)
    .to(alpha: 1, Math.floor(speed*0.75), Phaser.Easing.Bounce.Out, true)
    .to(alpha: 0, Math.floor(speed*0.25), Phaser.Easing.Bounce.In, true)
    
    setTimeout (=> @world.remove(text)), speed
    








