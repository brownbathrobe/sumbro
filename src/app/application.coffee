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
    $("#rainbow").on 'click', @rainbowTouch
    $(window).on 'deviceorientation', (e) =>
      @x = e.gamma
      @y = e.beta
      @z = e.alpha

  rainbowTouch: (e) =>
    @hue = "hsl(#{(e.clientX/window.innerWidth)*360}, 90%, 40%)"
    $('#rainbow').css
      'border-top' : "5px solid #{@hue}"

  pushGameState: ->
    setTimeout =>
      if not @disconnected
        data =
          x: @x
          y: @y
          z: @z
          id: @sessionid
          color: @hue
        @socket.emit 'move player', data
        @pushGameState()
    , 150

  onDisconnect: =>
    $('#arena').empty()
    @disconnected = yes

  onConnect: =>
    @sessionid = @socket.socket.sessionid
    @pushGameState()

  onRemovePlayer: (data) =>
    @players[data.id].remove()
    delete @players[data.id]

  onNewPlayer: (data) =>
    @players[data.id] = $ "<div class='ball' id='#{data.id}'></div>"
    @movePlayer
      el: @players[data.id]
      x: data.x
      y: data.y
    $('#arena').append @players[data.id]

  movePlayer: ({el, x, y}) ->
    el.css '-webkit-transform': "translate3d(#{x}px, #{y}px, 0)"

  onGameState: (data) =>
    for player in data
      el = @players[player.id]
      if not el
        newP = @onNewPlayer player
        el = @players[player.id]
      @movePlayer
        el: el
        x: player.pos.x
        y: player.pos.y
      el.removeClass 'king nextKing'
      if player.isKing
        el.addClass 'king'
      if player.isNextKing
        el.addClass 'nextKing'

module.exports = new Application
