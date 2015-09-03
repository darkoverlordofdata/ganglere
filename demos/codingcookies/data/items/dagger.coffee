#+--------------------------------------------------------------------+
#| items.coffee
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
# Define items
#

Game = require('./../../game')

Game.ItemRepository = new Game.Repository("items", Game.Item) unless Game.ItemRepository?

# Weapons
Game.ItemRepository.define "dagger",
  name: "dagger"
  character: ")"
  foreground: "gray"
  attackValue: 5
  wieldable: true
  mixins: [Game.ItemMixins.Equippable]
,
  disableRandomCreation: true

