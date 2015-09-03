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
Game.EntityRepository = new Game.Repository("entities", Game.Entity) unless Game.EntityRepository?
Game.EntityRepository.define "bat",
  name: "bat"
  character: "B"
  foreground: "white"
  maxHp: 5
  attackValue: 4
  speed: 2000
  mixins: [
    Game.EntityMixins.TaskActor
    Game.EntityMixins.Attacker
    Game.EntityMixins.Destructible
    Game.EntityMixins.CorpseDropper
    Game.EntityMixins.ExperienceGainer
    Game.EntityMixins.RandomStatGainer
  ]
