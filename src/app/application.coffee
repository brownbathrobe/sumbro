io = require 'socket.io-client'
Player = require './player.coffee'

class Application

  constructor: ->
    @socket = io.connect 'http://localhost:8000'
    @addListeners()

  addListeners: ->
    @socket.on 'connect', @onConnect, @
    @socket.on 'new player', @onNewPlayer, @
    @socket.on 'remove player', @onRemovePlayer, @

  onConnect: ->
    console.log 'connected!'

  onRemovePlayer: (data) ->
    console.log 'player removed:', data.id

  onNewPlayer: (data) ->
    console.log 'player added:', data.id

module.exports = new Application
