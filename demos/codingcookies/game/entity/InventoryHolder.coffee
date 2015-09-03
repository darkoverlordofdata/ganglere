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

Game.EntityMixins.InventoryHolder =
  name: "InventoryHolder"
  init: (template) ->
    
    # Default to 10 inventory slots.
    inventorySlots = template["inventorySlots"] or 10
    
    # Set up an empty inventory.
    @_items = new Array(inventorySlots)

  getItems: ->
    @_items

  getItem: (i) ->
    @_items[i]

  addItem: (item) ->
    
    # Try to find a slot, returning true only if we could add the item.
    i = 0

    while i < @_items.length
      unless @_items[i]
        @_items[i] = item
        return true
      i++
    false

  removeItem: (i) ->
    
    # If we can equip items, then make sure we unequip the item we are removing.
    @unequip @_items[i]  if @_items[i] and @hasMixin(Game.EntityMixins.Equipper)
    
    # Simply clear the inventory slot.
    @_items[i] = null

  canAddItem: ->
    
    # Check if we have an empty slot.
    i = 0

    while i < @_items.length
      return true  unless @_items[i]
      i++
    false

  pickupItems: (indices) ->
    
    # Allows the user to pick up items from the map, where indices is
    # the indices for the array returned by map.getItemsAt
    mapItems = @_map.getItemsAt(@getX(), @getY(), @getZ())
    added = 0
    
    # Iterate through all indices.
    i = 0

    while i < indices.length
      
      # Try to add the item. If our inventory is not full, then splice the 
      # item out of the list of items. In order to fetch the right item, we
      # have to offset the number of items already added.
      if @addItem(mapItems[indices[i] - added])
        mapItems.splice indices[i] - added, 1
        added++
      else
        
        # Inventory is full
        break
      i++
    
    # Update the map items
    @_map.setItemsAt @getX(), @getY(), @getZ(), mapItems
    
    # Return true only if we added all items
    added is indices.length

  dropItem: (i) ->
    
    # Drops an item to the current map tile
    if @_items[i]
      @_map.addItem @getX(), @getY(), @getZ(), @_items[i]  if @_map
      @removeItem i

