#+--------------------------------------------------------------------+
#| Cakefile
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2013
#+--------------------------------------------------------------------+
#|
#| This file is a part of Katra
#|
#| Katra is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# cake utils
#
fs = require 'fs'
util = require 'util'
{exec} = require 'child_process'
{nfcall} = require 'q'

#
# Build Source
#
#
task 'build', 'Build the coffee app', (options) ->


  start = new Date().getTime()

  nfcall exec, 'coffee -o tmp -c -b src'
  
  .then ->
    nfcall exec, 'browserify --debug tmp/index.js > www/js/ganglere.js'

  .then ->
    nfcall exec, 'browserify tmp/index.js | uglifyjs > www/js/ganglere.min.js'

  .fail ($err) ->
    util.error $err

  .done ($args) ->
    util.log $text for $text in $args when not /\s*/.test $text
    util.log "Compiled in #{new Date().getTime() - start} ms"
