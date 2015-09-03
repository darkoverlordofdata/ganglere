#+--------------------------------------------------------------------+
#| TargetBasedScreen.coffee
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
# Define screens
#
Game = require('./../../game')

Game.Screen = {} unless Game.Screen?

class Game.Screen.TargetBasedScreen

  constructor: (template) ->
    template = template or {}

    # By default, our ok return does nothing and does not consume a turn.
    @_isAcceptableFunction = template["okFunction"] or (x, y) ->
      false


    # The defaut caption function simply returns an empty string.
    @_captionFunction = template["captionFunction"] or (x, y) ->
      ""

  setup: (player, startX, startY, offsetX, offsetY) ->
    @_player = player

    # Store original position. Subtract the offset to make life easy so we don't
    # always have to remove it.
    @_startX = startX - offsetX
    @_startY = startY - offsetY

    # Store current cursor position
    @_cursorX = @_startX
    @_cursorY = @_startY

    # Store map offsets
    @_offsetX = offsetX
    @_offsetY = offsetY

    # Cache the FOV
    visibleCells = {}
    @_player.getMap().getFov(@_player.getZ()).compute @_player.getX(), @_player.getY(), @_player.getSightRadius(), (x, y, radius, visibility) ->
      visibleCells[x + "," + y] = true

    @_visibleCells = visibleCells

  render: (display) ->
    Game.Screen.playScreen.renderTiles.call Game.Screen.playScreen, display

    # Draw a line from the start to the cursor.
    points = Game.getLine(@_startX, @_startY, @_cursorX, @_cursorY)

    # Render stars along the line.
    i = 0
    l = points.length

    while i < l
      display.drawText points[i].x, points[i].y, "%c{magenta}*"
      i++

    # Render the caption at the bottom.
    display.drawText 0, Game.getScreenHeight() - 1, @_captionFunction(@_cursorX + @_offsetX, @_cursorY + @_offsetY)

  handleInput: (inputType, inputData) ->

    # Move the cursor
    if inputType is "keydown"
      if inputData.keyCode is ROT.VK_LEFT
        @moveCursor -1, 0
      else if inputData.keyCode is ROT.VK_RIGHT
        @moveCursor 1, 0
      else if inputData.keyCode is ROT.VK_UP
        @moveCursor 0, -1
      else if inputData.keyCode is ROT.VK_DOWN
        @moveCursor 0, 1
      else if inputData.keyCode is ROT.VK_ESCAPE
        Game.Screen.playScreen.setSubScreen `undefined`
      else @executeOkFunction()  if inputData.keyCode is ROT.VK_RETURN
    Game.refresh()

  moveCursor: (dx, dy) ->

    # Make sure we stay within bounds.
    @_cursorX = Math.max(0, Math.min(@_cursorX + dx, Game.getScreenWidth()))

    # We have to save the last line for the caption.
    @_cursorY = Math.max(0, Math.min(@_cursorY + dy, Game.getScreenHeight() - 1))

  executeOkFunction: ->

    # Switch back to the play screen.
    Game.Screen.playScreen.setSubScreen `undefined`

    # Call the OK function and end the player's turn if it return true.
    @_player.getMap().getEngine().unlock()  if @_okFunction(@_cursorX + @_offsetX, @_cursorY + @_offsetY)

