io = require 'socket.io-client'
Player = require './player.coffee'
$ = require '../../vendor/zepto.js'

class Application

  players: []

  constructor: ->
    @socket = io.connect "http://#{window.hostName}:8000"
    @addListeners()

  addListeners: ->
    @socket.on 'connect', @onConnect, @
    @socket.on 'new player', @onNewPlayer, @
    @socket.on 'remove player', @onRemovePlayer, @
    @socket.on 'game state', @onGameState, @

  onConnect: ->
    console.log 'connected!'

  onRemovePlayer: (data) ->
    console.log 'player removed:', data.id

  onNewPlayer: (data) ->
    console.log 'player added:', data.id

  onGameState: (data) ->
    for player in data
      el = $("##{player.id}")
      el.css 
        # left: ( player.pos.x-player.radius ) + 'px'
        # top: ( player.pos.y-player.radius )+ 'px'
        '-webkit-transform': "translate3d(#{player.pos.x - player.radius}px, #{player.pos.y - player.radius}px, 0)"


module.exports = new Application
