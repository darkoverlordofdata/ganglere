#+--------------------------------------------------------------------+
#| game.coffee
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
# Top Level Game object
#

module.exports = Game =

  _display: null
  _currentScreen: null
  _screenWidth: 80
  _screenHeight: 24


  #
  # load the game modules
  #
  init: ->

    # load the game logic
    require './game/Glyph'
    require './game/DynamicGlyph'
    require './game/Tile'
    require './game/Builder'
    require './game/Map'
    require './game/map/Cave'
    require './game/map/BossCavern'
    require './game/screen/ItemListScreen'
    require './game/screen/TargetBasedScreen'
    require './game/Entity'
    require './game/entity/PlayerActor'
    require './game/entity/FungusActor'
    require './game/entity/TaskActor'
    require './game/entity/GiantZombieActor'
    require './game/entity/Attacker'
    require './game/entity/Destructible'
    require './game/entity/MessageRecipient'
    require './game/entity/Sight'
    require './game/entity/InventoryHolder'
    require './game/entity/FoodConsumer'
    require './game/entity/CorpseDropper'
    require './game/entity/Equipper'
    require './game/entity/ExperienceGainer'
    require './game/entity/RandomStatGainer'
    require './game/entity/PlayerStatGainer'
    require './game/Item'
    require './game/item/Edible'
    require './game/item/Equippable'
    require './game/Repository'

    # load the game configuration
    require './data/screens/dropScreen'
    require './data/screens/eatScreen'
    require './data/screens/examineScreen'
    require './data/screens/gainStatScreen'
    require './data/screens/helpScreen'
    require './data/screens/inventoryScreen'
    require './data/screens/lookScreen'
    require './data/screens/loseScreen'
    require './data/screens/pickupScreen'
    require './data/screens/playScreen'
    require './data/screens/startScreen'
    require './data/screens/wearScreen'
    require './data/screens/wieldScreen'
    require './data/screens/winScreen'
    require './data/entities/PlayerTemplate'
    require './data/entities/bat'
    require './data/entities/fungus'
    require './data/entities/giant_zombie'
    require './data/entities/kobold'
    require './data/entities/newt'
    require './data/entities/slime'
    require './data/items/apple'
    require './data/items/melon'
    require './data/items/pumpkin'
    require './data/items/corpse'
    require './data/items/rock'
    require './data/items/dagger'
    require './data/items/sword'
    require './data/items/staff'
    require './data/items/tunic'
    require './data/items/chainmail'
    require './data/items/platemail'

    # Any necessary initialization will go here.
    @_display = new ROT.Display(
      width: @_screenWidth
      height: @_screenHeight + 1
    )
    
    # Create a helper function for binding to an event
    # and making it send it to the screen
    bindEventToScreen = (event) =>
      window.addEventListener event, (e) =>
        
        # When an event is received,
        # Send the event type and data to the screen
        @_currentScreen.handleInput event, e  if @_currentScreen?
        return
      return

    
    # Bind keyboard input events
    bindEventToScreen "keydown"
    
    #bindEventToScreen('keyup');
    bindEventToScreen "keypress"
    return

  #
  #
  #
  getDisplay: ->
    @_display

  #
  #
  #
  getScreenWidth: ->
    @_screenWidth

  #
  #
  #
  getScreenHeight: ->
    @_screenHeight

  #
  #
  #
  refresh: ->
    
    # Clear the screen
    @_display.clear()
    
    # Render the screen
    @_currentScreen.render @_display
    return

  #
  #
  #
  switchScreen: (screen) ->
    
    # If we had a screen before, notify it that we exited
    @_currentScreen.exit() if @_currentScreen isnt null
    
    # Clear the display
    @getDisplay().clear()
    
    # Update our current screen, notify it we entered
    # and then render it
    @_currentScreen = screen
    if not @_currentScreen isnt null
      @_currentScreen.enter()
      @refresh()
      return

  #
  # Helpers...
  #

  # Merge 2 objects
  merge: (src, dest) ->

    # Create a copy of the source.
    result = {}
    for key of src
      result[key] = src[key]

    # Copy over all keys from dest
    for key of dest
      result[key] = dest[key]
    result

  # Tile Helper function
  getNeighborPositions: (x, y) ->
    tiles = []

    for dX in [-1...2]
      for dY in [-1...2]

        # Make sure it isn't the same tile
        continue if dX is 0 and dY is 0
        tiles.push
          x: x + dX
          y: y + dY

    tiles.randomize()

  # Message sending functions
  sendMessage: (recipient, message, args) ->

    # Make sure the recipient can receive the message
    # before doing any work.
    if recipient.hasMixin(Game.EntityMixins.MessageRecipient)

      # If args were passed, then we format the message, else
      # no formatting is necessary
      message = vsprintf(message, args)  if args
      recipient.receiveMessage message

  sendMessageNearby: (map, centerX, centerY, centerZ, message, args) ->

    # If args were passed, then we format the message, else
    # no formatting is necessary
    message = vsprintf(message, args)  if args

    # Get the nearby entities
    entities = map.getEntitiesWithinRadius(centerX, centerY, centerZ, 5)

    # Iterate through nearby entities, sending the message if
    # they can receive it.
    i = 0

    while i < entities.length
      entities[i].receiveMessage message  if entities[i].hasMixin(Game.EntityMixins.MessageRecipient)
      i++


  getLine: (startX, startY, endX, endY) ->

    points = []
    dx = Math.abs(endX - startX)
    dy = Math.abs(endY - startY)
    sx = (if (startX < endX) then 1 else -1)
    sy = (if (startY < endY) then 1 else -1)
    err = dx - dy
    e2 = undefined
    loop
      points.push
        x: startX
        y: startY

      break  if startX is endX and startY is endY
      e2 = err * 2
      if e2 > -dx
        err -= dy
        startX += sx
      if e2 < dx
        err += dx
        startY += sy
    points
