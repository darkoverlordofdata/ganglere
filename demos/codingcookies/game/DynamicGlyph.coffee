#+--------------------------------------------------------------------+
#| dynamicglyph.coffee
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
# Define the basic glyph object
#

Game = require('./../game')

class Game.DynamicGlyph extends Game.Glyph

  constructor: (properties) ->
    properties = properties or {}
    
    # Call the glyph's construtor with our set of properties
    super properties
    
    # Instantiate any properties from the passed object
    @_name = properties["name"] or ""
    
    # Create an object which will keep track what mixins we have
    # attached to this entity based on the name property
    @_attachedMixins = {}
    
    # Create a similar object for groups
    @_attachedMixinGroups = {}
    
    # Set up an object for listeners
    @_listeners = {}
    
    # Setup the object's mixins
    mixins = properties["mixins"] or []
    i = 0
  
    while i < mixins.length
      
      # Copy over all properties from each mixin as long
      # as it's not the name, init, or listeners property. We
      # also make sure not to override a property that
      # already exists on the entity.
      for key of mixins[i]
        this[key] = mixins[i][key]  if key isnt "init" and key isnt "name" and key isnt "listeners" and not @hasOwnProperty(key)
      
      # Add the name of this mixin to our attached mixins
      @_attachedMixins[mixins[i].name] = true
      
      # If a group name is present, add it
      @_attachedMixinGroups[mixins[i].groupName] = true  if mixins[i].groupName
      
      # Add all of our listeners
      if mixins[i].listeners
        for key of mixins[i].listeners
          
          # If we don't already have a key for this event in our listeners
          # array, add it.
          @_listeners[key] = []  unless @_listeners[key]
          
          # Add the listener.
          @_listeners[key].push mixins[i].listeners[key]
      
      # Finally call the init function if there is one
      mixins[i].init.call this, properties  if mixins[i].init
      i++
    return

  hasMixin: (obj) ->
    
    # Allow passing the mixin itself or the name / group name as a string
    if typeof obj is "object"
      @_attachedMixins[obj.name]
    else
      @_attachedMixins[obj] or @_attachedMixinGroups[obj]
  
  setName: (name) ->
    @_name = name
  
  getName: ->
    @_name
  
  describe: ->
    @_name
  
  describeA: (capitalize) ->
    
    # Optional parameter to capitalize the a/an.
    prefixes = (if capitalize then [
      "A"
      "An"
    ] else [
      "a"
      "an"
    ])
    string = @describe()
    firstLetter = string.charAt(0).toLowerCase()
    
    # If word starts by a vowel, use an, else use a. Note that this is not perfect.
    prefix = (if "aeiou".indexOf(firstLetter) >= 0 then 1 else 0)
    prefixes[prefix] + " " + string
  
  describeThe: (capitalize) ->
    prefix = (if capitalize then "The" else "the")
    prefix + " " + @describe()
  
  raiseEvent: (event) ->
    
    # Make sure we have at least one listener, or else exit
    return  unless @_listeners[event]
    
    # Extract any arguments passed, removing the event name
    args = Array::slice.call(arguments, 1)
    
    # Invoke each listener, with this entity as the context and the arguments
    results = []
    i = 0
  
    while i < @_listeners[event].length
      results.push @_listeners[event][i].apply(this, args)
      i++
    results
  
  details: ->
    details = []
    detailGroups = @raiseEvent("details")
    
    # Iterate through each return value, grabbing the detaisl from the arrays.
    if detailGroups
      i = 0
      l = detailGroups.length
  
      while i < l
        if detailGroups[i]
          j = 0
  
          while j < detailGroups[i].length
            details.push detailGroups[i][j].key + ": " + detailGroups[i][j].value
            j++
        i++
    details.join ", "
