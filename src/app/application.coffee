io = require 'socket.io-client'
Player = require './player.coffee'
$ = require '../../vendor/zepto.js'

class Application


  constructor: ->
    @socket = io.connect "http://#{window.hostName}:8000"
    @players = {}
    @addListeners()

  addListeners: ->
    @socket.on 'connect', @onConnect
    @socket.on 'disconnect', @onDisconnect
    @socket.on 'new player', @onNewPlayer, @
    @socket.on 'remove player', @onRemovePlayer, @
    @socket.on 'game state', @onGameState, @
    $(window).on 'deviceorientation', (e) =>
      @x = e.gamma
      @y = e.beta
      @z = e.alpha

  pushGameState: ->
    setTimeout =>
      if not @disconnected
        data =
          x: @x
          y: @y
          z: @z
          id: @sessionid
        @socket.emit 'move player', data
        @pushGameState()
    , 150

  onDisconnect: =>
    @disconnected = yes

  onConnect: =>
    console.log 'connected!'
    @sessionid = @socket.socket.sessionid
    @pushGameState()


  onRemovePlayer: (data) =>
    @players[data.id].remove()
    delete @players[data.id]
    console.log 'player removed:', data.id, @players

  onNewPlayer: (data) =>
    @players[data.id] = $ "<div class='ball' id='#{data.id}'></div>"
    $('#arena').append @players[data.id]
    console.log 'player added:', data.id, @players

  onGameState: (data) =>
    for player in data
      el = @players[player.id]
      if not el
        newP = @onNewPlayer player
        el = @players[player.id]
      el.css
        '-webkit-transform': "translate3d(#{player.pos.x - player.radius}px, #{player.pos.y - player.radius}px, 0)"


module.exports = new Application
