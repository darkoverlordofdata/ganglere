#+--------------------------------------------------------------------+
#| repository.coffee
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

Game = require('./../game')

# A repository has a name and a constructor. The constructor is used to create
# items in the repository.
class Game.Repository
  
  constructor: (name, ctor) ->
    @_name = name
    @_templates = {}
    @_ctor = ctor
    @_randomTemplates = {}
    return
  
  
  # Define a new named template.
  define: (name, template, options) ->
    @_templates[name] = template
    
    # Apply any options
    disableRandomCreation = options and options["disableRandomCreation"]
    @_randomTemplates[name] = template  unless disableRandomCreation
    return
  
  
  # Create an object based on a template.
  create: (name, extraProperties) ->
    throw new Error("No template named '" + name + "' in repository '" + @_name + "'")  unless @_templates[name]
    
    # Copy the template
    template = Object.create(@_templates[name])
    
    # Apply any extra properties
    if extraProperties
      for key of extraProperties
        template[key] = extraProperties[key]
    
    # Create the object, passing the template as an argument
    new @_ctor(template)
  
  
  # Create an object based on a random template
  createRandom: ->
    
    # Pick a random key and create an object based off of it.
    @create Object.keys(@_randomTemplates).random()
