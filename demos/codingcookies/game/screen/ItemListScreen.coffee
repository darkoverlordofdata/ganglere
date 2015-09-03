#+--------------------------------------------------------------------+
#| ItemListScreen.coffee
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

class Game.Screen.ItemListScreen

  constructor: (template) ->
    
    # Set up based on the template
    @_caption = template["caption"]
    @_okFunction = template["ok"]
    
    # By default, we use the identity function
    @_isAcceptableFunction = template["isAcceptable"] or (x) ->
      x
  
    
    # Whether the user can select items at all.
    @_canSelectItem = template["canSelect"]
    
    # Whether the user can select multiple items.
    @_canSelectMultipleItems = template["canSelectMultipleItems"]
    
    # Whether a 'no item' option should appear.
    @_hasNoItemOption = template["hasNoItemOption"]
  
  setup: (player, items) ->
    @_player = player
    
    # Should be called before switching to the screen.
    count = 0
    
    # Iterate over each item, keeping only the aceptable ones and counting
    # the number of acceptable items.
    that = this
    @_items = items.map((item) ->
      
      # Transform the item into null if it's not acceptable
      if that._isAcceptableFunction(item)
        count++
        item
      else
        null
    )
    
    # Clean set of selected indices
    @_selectedIndices = {}
    count
  
  render: (display) ->
    letters = "abcdefghijklmnopqrstuvwxyz"
    
    # Render the caption in the top row
    display.drawText 0, 0, @_caption
    
    # Render the no item row if enabled
    display.drawText 0, 1, "0 - no item"  if @_hasNoItemOption
    row = 0
    i = 0
  
    while i < @_items.length
      
      # If we have an item, we want to render it.
      if @_items[i]
        
        # Get the letter matching the item's index
        letter = letters.substring(i, i + 1)
        
        # If we have selected an item, show a +, else show a dash between
        # the letter and the item's name.
        selectionState = (if (@_canSelectItem and @_canSelectMultipleItems and @_selectedIndices[i]) then "+" else "-")
        
        # Check if the item is worn or wielded
        suffix = ""
        if @_items[i] is @_player.getArmor()
          suffix = " (wearing)"
        else suffix = " (wielding)"  if @_items[i] is @_player.getWeapon()
        
        # Render at the correct row and add 2.
        display.drawText 0, 2 + row, letter + " " + selectionState + " " + @_items[i].describe() + suffix
        row++
      i++
  
  executeOkFunction: ->
    
    # Gather the selected items.
    selectedItems = {}
    for key of @_selectedIndices
      selectedItems[key] = @_items[key]
    
    # Switch back to the play screen.
    Game.Screen.playScreen.setSubScreen `undefined`
    
    # Call the OK function and end the player's turn if it return true.
    @_player.getMap().getEngine().unlock()  if @_okFunction(selectedItems)
  
  handleInput: (inputType, inputData) ->
    if inputType is "keydown"
      
      # If the user hit escape, hit enter and can't select an item, or hit
      # enter without any items selected, simply cancel out
      if inputData.keyCode is ROT.VK_ESCAPE or (inputData.keyCode is ROT.VK_RETURN and (not @_canSelectItem or Object.keys(@_selectedIndices).length is 0))
        Game.Screen.playScreen.setSubScreen `undefined`
      
      # Handle pressing return when items are selected
      else if inputData.keyCode is ROT.VK_RETURN
        @executeOkFunction()
      
      # Handle pressing zero when 'no item' selection is enabled
      else if @_canSelectItem and @_hasNoItemOption and inputData.keyCode is ROT.VK_0
        @_selectedIndices = {}
        @executeOkFunction()
      
      # Handle pressing a letter if we can select
      else if @_canSelectItem and inputData.keyCode >= ROT.VK_A and inputData.keyCode <= ROT.VK_Z
        
        # Check if it maps to a valid item by subtracting 'a' from the character
        # to know what letter of the alphabet we used.
        index = inputData.keyCode - ROT.VK_A
        if @_items[index]
          
          # If multiple selection is allowed, toggle the selection status, else
          # select the item and exit the screen
          if @_canSelectMultipleItems
            if @_selectedIndices[index]
              delete @_selectedIndices[index]
            else
              @_selectedIndices[index] = true
            
            # Redraw screen
            Game.refresh()
          else
            @_selectedIndices[index] = true
            @executeOkFunction()
  
