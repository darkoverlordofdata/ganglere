#+--------------------------------------------------------------------+
#| Map.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Ganglere
#|
#| Ganglere is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Ganglere - The Deluding of Gylfe
#
# Map
#
"use strict"

ganglere = require('../ganglere')

# ----------------------------
# Map
# ----------------------------
class ganglere.Map

  tiles       : null
  rotmap      : null
  phaserMap   : null
  lightDict   : {}
  
  constructor: (@rotmap, @phaserMap) ->
    @tiles=JSON.parse(JSON.stringify(@rotmap.map))

  exist:(x,y) =>
    return if (typeof @rotmap.map[x] isnt 'undefined' and typeof @rotmap.map[x][y]isnt 'undefined' and @rotmap.map[x][y] is 0) then '1' else '0'
  
  
  canGo: (actor,dir) =>
    return  actor.x+dir.x >= 0 and
      actor.x+dir.x < ganglere.COLS and
      actor.y+dir.y >= 0 and
      actor.y+dir.y < ganglere.ROWS  and
      @tiles[actor.x+dir.x][actor.y+dir.y] is 0
  
  light:() =>
    #/* input callback */
    lightPasses = (x, y) =>
        return typeof @tiles[x] is 'undefined' or typeof @tiles[x][y] is 'undefined' or @tiles[x][y] is 0
    

    @resetLight()

    @fov = new ROT.FOV.PreciseShadowcasting(lightPasses)
    @computeLight()
  
  resetLight:() =>

    for x in [0...ganglere.COLS]
      for y in [0...ganglere.ROWS]
        tile=@phaserMap.getTile(x,y,0)
        if(tile)
          tile.alpha=0

        tile=@phaserMap.getTile(x,y,1)
        if(tile)
          tile.alpha=0

  computeLight:() =>
    @resetLight()

    ganglere.actorList.forEach (a) ->
      a.sprite.alpha=0

    ganglere.actorList[0].sprite.alpha=1
    @fov.compute ganglere.actorList[0].x, ganglere.actorList[0].y, 10, (x, y, r, visibility) =>
      tile=@phaserMap.getTile(x,y,0)
      if(tile)
        tile.alpha=visibility
      
      tile=@phaserMap.getTile(x,y,1)
      if(tile)
        tile.alpha=visibility
      
      if(ganglere.actorMap.hasOwnProperty(x+'_'+y))
        ganglere.actorMap[x+'_'+y].sprite.alpha=visibility
      

    @phaserMap.layers[0].dirty=true
    @phaserMap.layers[1].dirty=true
  

  @generateMap: (keyName, _cache, width, height, tilewidth, tileheight) ->

    _map = new ROT.Map.Rogue(width, height)

    ARENA=35

    jsonmap=
      layers:[
        {
          data:new Array(width*height)
          height:height
          name:'ground'
          opacity:1
          type:'tilelayer'
          visible:true
          width:width
          x:0
          y:0
        },{
          data:[]
          height:height
          name:'decoration'
          opacity:1
          type:'tilelayer'
          visible:true
          width:width
          x:0
          y:0
        }
      ]
      orientation:'orthogonal'
      properties:{}
      tileheight:tileheight
      tilesets:[{
        firstgid:1
        image:'assets/images/foresttiles_0.png'
        imagewidth:160
        imageheight:224
        margin:0
        name:'forest-tiles'
        properties:{}
        spacing:0
        tileheight:tileheight
        tilewidth:tilewidth
        }]
      tilewidth:tilewidth
      version:1
      height:tileheight
      width:tilewidth



    #  map.addTilesetImage('terrain_atlas')

    _map.create (x,y,v)->
      jsonmap.layers[0].data[y*width+x]= if (v is 1) then 0 else ARENA


    _cache.addTilemap(keyName,'', jsonmap)

    _exist=(x,y)->
      return if (typeof _map.map[x] isnt 'undefined' and typeof _map.map[x][y] isnt 'undefined' and _map.map[x][y] is 0) then '1' else '0'




    cbSetBackground = (tile)->
      return () ->
        jsonmap.layers[0].data[tilepos] = ARENA
        jsonmap.layers[1].data[tilepos] = tile



    patternArray = []
    addPattern = (pattern,cb)->
      patternArray.push
        regex:new RegExp(pattern.replace(/\*/g,'[0-1]'))
        cb:cb




    addPattern(
      '000'+
      '0*0'+
      '*1*',(tilepos,x,y) ->
        cbSetBackground(14)()
        if(y>0)
          jsonmap.layers[1].data[(y-1)*width+x]=9


      )

    addPattern(
      '000'+
      '0*0'+
      '1*1',(tilepos,x,y) ->
        cbSetBackground(14)()
        if(y>0)
          jsonmap.layers[1].data[(y-1)*width+x]=9


      )

    addPattern(
      '000'+
      '0*0'+
      '001',(tilepos,x,y) ->
        cbSetBackground(6)()
        if(y>0)
          jsonmap.layers[1].data[(y-1)*width+x]=1


      )

    addPattern(
      '00*'+
      '0*1'+
      '*11',(tilepos,x,y) ->
        cbSetBackground(15)()
        if(y>0)
          jsonmap.layers[1].data[(y-1)*width+x]=10

      )

    addPattern(
      '00*'+
      '0*1'+
      '101',(tilepos,x,y) ->
        cbSetBackground(15)()
        if(y>0)
          jsonmap.layers[1].data[(y-1)*width+x]=10

      )

    addPattern(
      '000'+
      '0*0'+
      '100',(tilepos,x,y) ->
        cbSetBackground(7)()
        if(y>0)
          jsonmap.layers[1].data[(y-1)*width+x]=2

      )

    addPattern(
      '00*'+
      '0*1'+
      '00*',cbSetBackground(10))

    addPattern(
      '*1*'+
      '0*0'+
      '000',cbSetBackground(4))


    addPattern(
      '**1'+
      '0*0'+
      '000',cbSetBackground(11))

    addPattern(
      '111'+
      '0**'+
      '001',cbSetBackground(5))


    addPattern(
      '*00'+
      '1*0'+
      '*00',cbSetBackground(8))


    addPattern(
      '*00'+
      '**0'+
      '11*',cbSetBackground(13))

    addPattern(
      '*1*'+
      '1*0'+
      '*00',cbSetBackground(3))

    addPattern(
      '1**'+
      '**0'+
      '*00',cbSetBackground(12))

    addPattern(
      '**1'+
      '0**'+
      '00*',cbSetBackground(5))
    addPattern(
      '001'+
      '0*0'+
      '111',cbSetBackground(15))


    addPattern(
      '*00'+
      '1*0'+
      '1*1',cbSetBackground(13))




    addPattern(
      '*1*'+
      '***'+
      '*1*',() ->
        jsonmap.layers[0].data[tilepos]= ARENA
        f=[18,23,18]
        f=f[Math.floor((Math.random()*3))]
        jsonmap.layers[1].data[tilepos]=f
    )
    addPattern(
      '***'+
      '1*1'+
      '***',() ->
        jsonmap.layers[0].data[tilepos]= ARENA
        f=[18,23,18]
        f=f[Math.floor((Math.random()*3))]
        jsonmap.layers[1].data[tilepos]=f
    )



    for y in [0..._map._height]
      for x in [0..._map._width]
        jsonmap.layers[1].data.push(0)
        if(_map.map[x][y] is 0)
          continue


        tilepos=y*width+x
        direction=_exist(x-1,y-1)+_exist(x,y-1)+_exist(x+1,y-1)+_exist(x-1,y)+'1'+_exist(x+1,y)+_exist(x-1,y+1)+_exist(x,y+1)+_exist(x+1,y+1)

        for i in [0...patternArray.length]
          if(patternArray[i].regex.test(direction))
            patternArray[i].cb(tilepos, x, y)
            break

    return _map



