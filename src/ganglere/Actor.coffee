#+--------------------------------------------------------------------+
#| Actor.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| @ file is a part of Ganglere
#|
#| Ganglere is free software you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Ganglere - The Deluding of Gylfe
#
# Actor
#
"use strict"

ganglere = require('../ganglere')

# ----------------------------
# Actor base class
# ----------------------------
class ganglere.Actor

  @all        : []          # list of all actors
  @map        : {}          # actor position map

  {FRAME_FRONT, FRAME_BACK, FRAME_LEFT, FRAME_RIGHT} = ganglere.config

  WHITE       = '#fff'      # Enemy damage pts
  HUNTER      = '#ff0044'   # Player damage pts

  isPlayer    : false       # is this actor the player?
  game        : null        # current game
  sprite      : null        # sprite object to display
  x           : 0           # x position
  y           : 0           # y position
  hp          : 0           # remaining health points
  damage      : "d8+2"      # damage calculation
  
  #
  # new Actor
  #
  # @param  [Phaser.State]  game state
  # @param  [Number]  x coord
  # @param  [Number]  y coord
  # @param  [String]  key
  # @return	Nothing
  #
  constructor: (game, x, y, key) ->
  
    @hp = 3
    @x = x
    @y = y
    @config = ganglere.config.sprites[key]
    @setOfset @config.axis
    @key = if @config.selected? then "#{key}[#{@config.selected}]" else key
      
      
    if game
      @game = game
      @sprite = game.add.sprite(x * 32, y * 32, @key)

  move: =>
  

  attack: (victim) =>
    damage = ganglere.Random.diceRoll(@damage).total
    victim.hp -= damage
    axis = if (@x is victim.x) then "y" else "x"
    dir = victim[axis] - this[axis]
    dir = dir / Math.abs(dir) # +1 or -1
    pos1 = {}
    pos2 = {}
    pos1[axis] = (dir * 15).toString()
    pos2[axis] = (dir * 15 * (-1)).toString()


    @game.camera.follow false
    @game.add.tween(@sprite)
    .to(pos1, 200, Phaser.Easing.Elastic.In, true)
    .to(pos2, 200, Phaser.Easing.Elastic.Out, true)
    .onComplete.add (=> @game.camera.follow @sprite), this
    color = if victim.isPlayer then HUNTER else WHITE
    @game.showDamage damage.toString(), victim.sprite, 450, color
  
  
  
  #
  # Set X,Y
  #
  # @param  [Number]  x coord
  # @param  [Number]  y coord
  # @return	Nothing
  #
  setXY: (x, y) =>
    @x = x
    @y = y
    @game.add.tween(@sprite).to
      x: x * 32
      y: y * 32
    , 500, Phaser.Easing.Linear.None, true
    return


  #
  # Set Ofset
  #
  # @param  [Number]  axis in sprite image
  # @return	Nothing
  #
  setOfset: (axis) =>
    
    switch @config.type
    
      when 0 # horizontal
        
        r0 = axis * 4 + @config.order[0]
        r1 = axis * 4 + @config.order[1]
        r2 = axis * 4 + @config.order[2]
        r3 = axis * 4 + @config.order[3]
      
      when 1 # vertical
        
        r0 = axis + @config.cols * @config.order[0]
        r1 = axis + @config.cols * @config.order[1]
        r2 = axis + @config.cols * @config.order[2]
        r3 = axis + @config.cols * @config.order[3]
    
      else
        r0 = 0
        r1 = 0
        r2 = 0
        r3 = 0
    
    
    @ofset = [r0,r1,r2,r3]
    
  
  #
  # Set Frame - set the frome to match the direction
  #
  # @param  [Coord]  x/y coord
  # @return	Nothing
  #
  setFrame: (dir) =>
    if dir.x is 1
      @sprite.frame = @ofset[FRAME_RIGHT]
    else if dir.x is -1
      @sprite.frame = @ofset[FRAME_LEFT]
    else if dir.y is -1
      @sprite.frame = @ofset[FRAME_BACK]
    else if dir.y is 1
      @sprite.frame = @ofset[FRAME_FRONT]
