#+--------------------------------------------------------------------+
#| playScreen.coffee
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


# Define our playing screen
Game.Screen.playScreen =

  _player: null
  _gameEnded: false
  _subScreen: null

  enter: ->
    
    # Create a map based on our size parameters
    width = 100
    height = 48
    depth = 6
    
    # Create our map from the tiles and player
    @_player = new Game.Entity(Game.PlayerTemplate)
    tiles = new Game.Builder(width, height, depth).getTiles()
    map = new Game.Map.Cave(tiles, @_player)
    
    # Start the map's engine
    map.getEngine().start()

  exit: ->
    console.log "Exited play screen."

  render: (display) ->
    
    # Render subscreen if there is one
    if @_subScreen
      @_subScreen.render display
      return
    screenWidth = Game.getScreenWidth()
    screenHeight = Game.getScreenHeight()
    
    # Render the tiles
    @renderTiles display
    
    # Get the messages in the player's queue and render them
    messages = @_player.getMessages()
    messageY = 0
    i = 0

    while i < messages.length
      
      # Draw each message, adding the number of lines
      messageY += display.drawText(0, messageY, "%c{white}%b{black}" + messages[i])
      i++
    
    # Render player stats
    stats = "%c{white}%b{black}"
    stats += vsprintf("HP: %d/%d L: %d XP: %d", [
      @_player.getHp()
      @_player.getMaxHp()
      @_player.getLevel()
      @_player.getExperience()
    ])
    display.drawText 0, screenHeight, stats
    
    # Render hunger state
    hungerState = @_player.getHungerState()
    display.drawText screenWidth - hungerState.length, screenHeight, hungerState

  getScreenOffsets: ->
    
    # Make sure we still have enough space to fit an entire game screen
    topLeftX = Math.max(0, @_player.getX() - (Game.getScreenWidth() / 2))
    
    # Make sure we still have enough space to fit an entire game screen
    topLeftX = Math.min(topLeftX, @_player.getMap().getWidth() - Game.getScreenWidth())
    
    # Make sure the y-axis doesn't above the top bound
    topLeftY = Math.max(0, @_player.getY() - (Game.getScreenHeight() / 2))
    
    # Make sure we still have enough space to fit an entire game screen
    topLeftY = Math.min(topLeftY, @_player.getMap().getHeight() - Game.getScreenHeight())
    x: topLeftX
    y: topLeftY

  renderTiles: (display) ->
    screenWidth = Game.getScreenWidth()
    screenHeight = Game.getScreenHeight()
    offsets = @getScreenOffsets()
    topLeftX = offsets.x
    topLeftY = offsets.y
    
    # This object will keep track of all visible map cells
    visibleCells = {}
    
    # Store this._player.getMap() and player's z to prevent losing it in callbacks
    map = @_player.getMap()
    currentDepth = @_player.getZ()
    
    # Find all visible cells and update the object
    map.getFov(currentDepth).compute @_player.getX(), @_player.getY(), @_player.getSightRadius(), (x, y, radius, visibility) ->
      visibleCells[x + "," + y] = true
      
      # Mark cell as explored
      map.setExplored x, y, currentDepth, true

    
    # Render the explored map cells
    x = topLeftX

    while x < topLeftX + screenWidth
      y = topLeftY

      while y < topLeftY + screenHeight
        if map.isExplored(x, y, currentDepth)
          
          # Fetch the glyph for the tile and render it to the screen
          # at the offset position.
          glyph = map.getTile(x, y, currentDepth)
          foreground = glyph.getForeground()
          
          # If we are at a cell that is in the field of vision, we need
          # to check if there are items or entities.
          if visibleCells[x + "," + y]
            
            # Check for items first, since we want to draw entities
            # over items.
            items = map.getItemsAt(x, y, currentDepth)
            
            # If we have items, we want to render the top most item
            glyph = items[items.length - 1]  if items
            
            # Check if we have an entity at the position
            glyph = map.getEntityAt(x, y, currentDepth)  if map.getEntityAt(x, y, currentDepth)
            
            # Update the foreground color in case our glyph changed
            foreground = glyph.getForeground()
          else
            
            # Since the tile was previously explored but is not 
            # visible, we want to change the foreground color to
            # dark gray.
            foreground = "darkGray"
          display.draw x - topLeftX, y - topLeftY, glyph.getChar(), foreground, glyph.getBackground()
        y++
      x++

  handleInput: (inputType, inputData) ->
    
    # If the game is over, enter will bring the user to the losing screen.
    if @_gameEnded
      Game.switchScreen Game.Screen.loseScreen  if inputType is "keydown" and inputData.keyCode is ROT.VK_RETURN
      
      # Return to make sure the user can't still play
      return
    
    # Handle subscreen input if there is one
    if @_subScreen
      @_subScreen.handleInput inputType, inputData
      return
    if inputType is "keydown"
      
      # Movement
      if inputData.keyCode is ROT.VK_LEFT
        @move -1, 0, 0
      else if inputData.keyCode is ROT.VK_RIGHT
        @move 1, 0, 0
      else if inputData.keyCode is ROT.VK_UP
        @move 0, -1, 0
      else if inputData.keyCode is ROT.VK_DOWN
        @move 0, 1, 0
      else if inputData.keyCode is ROT.VK_I
        
        # Show the inventory screen
        @showItemsSubScreen Game.Screen.inventoryScreen, @_player.getItems(), "You are not carrying anything."
        return
      else if inputData.keyCode is ROT.VK_D
        
        # Show the drop screen
        @showItemsSubScreen Game.Screen.dropScreen, @_player.getItems(), "You have nothing to drop."
        return
      else if inputData.keyCode is ROT.VK_E
        
        # Show the drop screen
        @showItemsSubScreen Game.Screen.eatScreen, @_player.getItems(), "You have nothing to eat."
        return
      else if inputData.keyCode is ROT.VK_W
        if inputData.shiftKey
          
          # Show the wear screen
          @showItemsSubScreen Game.Screen.wearScreen, @_player.getItems(), "You have nothing to wear."
        else
          
          # Show the wield screen
          @showItemsSubScreen Game.Screen.wieldScreen, @_player.getItems(), "You have nothing to wield."
        return
      else if inputData.keyCode is ROT.VK_X
        
        # Show the drop screen
        @showItemsSubScreen Game.Screen.examineScreen, @_player.getItems(), "You have nothing to examine."
        return
      else if inputData.keyCode is ROT.VK_COMMA
        items = @_player.getMap().getItemsAt(@_player.getX(), @_player.getY(), @_player.getZ())
        
        # If there is only one item, directly pick it up
        if items and items.length is 1
          item = items[0]
          if @_player.pickupItems([0])
            Game.sendMessage @_player, "You pick up %s.", [item.describeA()]
          else
            Game.sendMessage @_player, "Your inventory is full! Nothing was picked up."
        else
          @showItemsSubScreen Game.Screen.pickupScreen, items, "There is nothing here to pick up."
      else
        
        # Not a valid key
        return
      
      # Unlock the engine
      @_player.getMap().getEngine().unlock()
    else if inputType is "keypress"
      keyChar = String.fromCharCode(inputData.charCode)
      if keyChar is ">"
        @move 0, 0, 1
      else if keyChar is "<"
        @move 0, 0, -1
      else if keyChar is ";"
        
        # Setup the look screen.
        offsets = @getScreenOffsets()
        Game.Screen.lookScreen.setup @_player, @_player.getX(), @_player.getY(), offsets.x, offsets.y
        @setSubScreen Game.Screen.lookScreen
        return
      else if keyChar is "?"
        
        # Setup the look screen.
        @setSubScreen Game.Screen.helpScreen
        return
      else
        
        # Not a valid key
        return
      
      # Unlock the engine
      @_player.getMap().getEngine().unlock()

  move: (dX, dY, dZ) ->
    newX = @_player.getX() + dX
    newY = @_player.getY() + dY
    newZ = @_player.getZ() + dZ
    
    # Try to move to the new cell
    @_player.tryMove newX, newY, newZ, @_player.getMap()

  setGameEnded: (gameEnded) ->
    @_gameEnded = gameEnded

  setSubScreen: (subScreen) ->
    @_subScreen = subScreen
    
    # Refresh screen on changing the subscreen
    Game.refresh()

  showItemsSubScreen: (subScreen, items, emptyMessage) ->
    if items and subScreen.setup(@_player, items) > 0
      @setSubScreen subScreen
    else
      Game.sendMessage @_player, emptyMessage
      Game.refresh()


