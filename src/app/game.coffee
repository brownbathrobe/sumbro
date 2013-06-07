_ = require 'underscore'
io = require 'socket.io'
socket = io.listen(8000)

class Game

  constructor: ->
    @players = {}
    @socket = socket
    @setupSockets()
    @setEventHandlers()

  setupSockets: ->
    @socket.configure =>
      @socket.set "transports", ['websocket' ,'flashsocket', 'htmlfile', 'xhr-polling', 'jsonp-polling']
      @socket.set "log level", 2

  setEventHandlers: ->
    @socket.sockets.on 'connection', @onSocketConnection

  onSocketConnection: (client) =>
    data = id: client.id
    @addPlayer data
    self = this
    client.on "disconnect", ->
      data = id: @id
      self.removePlayer data
    client.on "move player", @onMovePlayer

  onMovePlayer: ->

  addPlayer: (player) =>
    @players[player.id] = player
    @socket.sockets.emit 'new player', player

  removePlayer: (player) =>
    delete @players[player.id]
    @socket.sockets.emit 'remove player', player

  destructor: ->
    @socket.server.close()

module.exports = Game
