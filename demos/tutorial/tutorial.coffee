Game =

  display: null
  map: {}
  engine: null
  player: null
  pedro: null
  ananas: null

  init: ->
    @display = new ROT.Display(spacing: 1.1)
    document.body.appendChild @display.getContainer()
    @generateMap()
    scheduler = new ROT.Scheduler.Simple()
    scheduler.add @player, true
    scheduler.add @pedro, true
    @engine = new ROT.Engine(scheduler)
    @engine.start()

  generateMap: ->
    digger = new ROT.Map.Digger()
    freeCells = []

    digger.create (x, y, value) =>
      return if value
      key = x + "," + y
      @map[key] = "."
      freeCells.push key

    @generateBoxes freeCells
    @drawWholeMap()
    @player = @createBeing(Player, freeCells)
    @pedro = @createBeing(Pedro, freeCells)

  createBeing: (BeingClass, freeCells) ->
    index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
    key = freeCells.splice(index, 1)[0]
    parts = key.split(",")
    x = parseInt(parts[0])
    y = parseInt(parts[1])
    new BeingClass(x, y)

  generateBoxes: (freeCells) ->
    i = 0
    while i < 10
      index = Math.floor(ROT.RNG.getUniform() * freeCells.length)
      key = freeCells.splice(index, 1)[0]
      @map[key] = "*"
      @ananas = key  unless i # first box contains an ananas
      i++
    return

  drawWholeMap: ->
    for key of @map
      parts = key.split(",")
      x = parseInt(parts[0])
      y = parseInt(parts[1])
      @display.draw x, y, @map[key]
    return

class Player 
  
  constructor: (x, y) ->
    @x = x
    @y = y
    @draw()
  
  getSpeed: ->
    100
  
  getX: ->
    @x
  
  getY: ->
    @y
  
  act: ->
    Game.engine.lock()
    window.addEventListener "keydown", this
  
  handleEvent: (e) ->
    code = e.keyCode
    if code is 13 or code is 32
      @checkBox()
      return
    keyMap = {}
    keyMap[38] = 0
    keyMap[33] = 1
    keyMap[39] = 2
    keyMap[34] = 3
    keyMap[40] = 4
    keyMap[35] = 5
    keyMap[37] = 6
    keyMap[36] = 7
    
    # one of numpad directions? 
    return unless code of keyMap
    
    # is there a free space? 
    dir = ROT.DIRS[8][keyMap[code]]
    newX = @x + dir[0]
    newY = @y + dir[1]
    newKey = newX + "," + newY
    return unless newKey of Game.map
    Game.display.draw @x, @y, Game.map[@x + "," + @y]
    @x = newX
    @y = newY
    @draw()
    window.removeEventListener "keydown", this
    Game.engine.unlock()
  
  draw: ->
    Game.display.draw @x, @y, "@", "#ff0"
  
  checkBox: ->
    key = @x + "," + @y
    unless Game.map[key] is "*"
      alert "There is no box here!"
    else if key is Game.ananas
      alert "Hooray! You found an ananas and won this game."
      Game.engine.lock()
      window.removeEventListener "keydown", this
    else
      alert "This box is empty :-("
  
class Pedro
  
  constructor: (x, y) ->
    @x = x
    @y = y
    @draw()
  
  getSpeed: ->
    100
  
  act: ->
    x = Game.player.getX()
    y = Game.player.getY()
    passableCallback = (x, y) ->
      x + "," + y of Game.map
  
    astar = new ROT.Path.AStar(x, y, passableCallback,
      topology: 4
    )
    path = []
    pathCallback = (x, y) ->
      path.push [
        x
        y
      ]
  
    astar.compute @x, @y, pathCallback
    path.shift()
    if path.length is 1
      Game.engine.lock()
      alert "Game over - you were captured by Pedro!"
    else
      x = path[0][0]
      y = path[0][1]
      Game.display.draw @x, @y, Game.map[@x + "," + @y]
      @x = x
      @y = y
      @draw()
  
  draw: ->
    Game.display.draw @x, @y, "P", "red"

