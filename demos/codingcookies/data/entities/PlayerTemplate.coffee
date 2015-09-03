#+--------------------------------------------------------------------+
#| entities.coffee
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
# Define the builder object
#

Game = require('./../../game')

# Player template
Game.PlayerTemplate =
  name: "human (you)"
  character: "@"
  foreground: "white"
  maxHp: 40
  attackValue: 10
  sightRadius: 6
  inventorySlots: 22
  mixins: [
    Game.EntityMixins.PlayerActor
    Game.EntityMixins.Attacker
    Game.EntityMixins.Destructible
    Game.EntityMixins.InventoryHolder
    Game.EntityMixins.FoodConsumer
    Game.EntityMixins.Sight
    Game.EntityMixins.MessageRecipient
    Game.EntityMixins.Equipper
    Game.EntityMixins.ExperienceGainer
    Game.EntityMixins.PlayerStatGainer
  ]

