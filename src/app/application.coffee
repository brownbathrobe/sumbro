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
        left: ( player.pos.x-20 ) + 'px'
        top: ( player.pos.y-20 )+ 'px'


module.exports = new Application
