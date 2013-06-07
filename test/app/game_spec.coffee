sinon = require 'sinon'
Game = require '../../src/app/game.coffee'
io = require 'socket.io-client'

describe 'Game', ->

  before ->
    @game = new Game

  it 'can be required', ->
    Game.should.be.OK

  it 'is a function', ->
    game = new Game

  it 'has players that defaults to 0', ->
    @game.players.length.should.equal 0

  it 'can add a player', ->
    player = {}
    @game.addPlayer player
    @game.players.length.should.equal 1
    @game.players[0].should.equal player

  it 'can remove a player', ->
    player = name: 'me'
    @game.addPlayer player
    @game.removePlayer player
    @game.players.should.not.include player

  xit 'can accept a new connection', (done) ->
    spy = sinon.spy()
    socketFunc = ->
      socket.disconnect()
      done()
    @game.socket.on 'connection', socketFunc
    socket = io.connect('http://localhost:8000')

  xit 'can handle a client disconnect', (done) ->
    spy = sinon.spy @game, 'onPlayerDisconnect'
    socketFunc = ->
      console.log 'YUNOFUNC'
      socket.disconnect()
      setTimeout ->
        spy.callCount.should.equal 1
        done()
      , 100
    @game.socket.on 'connection', socketFunc
    socket = io.connect('http://localhost:8000')

  it 'can handle a new player event', (done) ->
    spy = sinon.spy @game, 'onNewPlayer'
    socket = io.connect('http://localhost:8000')
    @game.socket.on 'connection', ->
      data = name: 'bob'
      socket.emit 'new player', data
      setTimeout ->
        spy.callCount.should.equal 1
        done()
      , 100
