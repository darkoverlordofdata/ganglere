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

# Create our central entity repository
Game.EntityRepository = new Game.Repository("entities", Game.Entity)
Game.EntityRepository.define "kobold",
  name: "kobold"
  character: "k"
  foreground: "white"
  maxHp: 6
  attackValue: 4
  sightRadius: 5
  tasks: [
    "hunt"
    "wander"
  ]
  mixins: [
    Game.EntityMixins.TaskActor
    Game.EntityMixins.Sight
    Game.EntityMixins.Attacker
    Game.EntityMixins.Destructible
    Game.EntityMixins.CorpseDropper
    Game.EntityMixins.ExperienceGainer
    Game.EntityMixins.RandomStatGainer
  ]

