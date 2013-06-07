_ = require 'underscore'
io = require 'socket.io'
socket = io.listen(8000)
Physics = require '../../vendor/coffeephysics/engine/Physics.coffee'
Particle = require '../../vendor/coffeephysics/engine/Particle.coffee'
Collision = require '../../vendor/coffeephysics/behaviour/Collision.coffee'
EdgeBounce = require '../../vendor/coffeephysics/behaviour/EdgeBounce.coffee'
Attraction = require '../../vendor/coffeephysics/behaviour/Attraction.coffee'
Behaviour = require '../../vendor/coffeephysics/behaviour/Behaviour.coffee'
Vector = require '../../vendor/coffeephysics/math/Vector.coffee'

class Game

  width: 600
  height: 600
  particlesize: 40
  colors:[
    'red',
    'blue',
    'green',
    'orange',
    'navy',
    'lime'
    ]

  constructor: ->
    @players = {}
    @socket = socket
    @setupSockets()
    @setupPhysics()
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

    player = new Particle()
    player.setRadius @particlesize/2
    # player.el = ($ "<div class='ball user'/>")
    color = @colors[parseInt(Math.random()*@colors.length)]
    x = Math.random()*@width
    y = Math.random()*@height
    player.moveTo new Vector x, y
    
    @collision.pool.push player
    player.behaviours.push @collision, @bounds, @center
    @physics.particles.push player

  update: ->
    @physics.step()
    setTimeout =>
      @update()
    , 15

  gameState: ->
    gameData = []
    for player in @physics.particles
      gameData.push
        id: player.id
        pos: player.pos
        vel: player.vel
        acc: player.acc
        radius: player.radius
        mass: player.mass
    @socket.sockets.emit 'game state', gameData
    setTimeout =>
      @gameState()
    , 22

  removePlayer: (player) =>
    delete @players[player.id]
    @socket.sockets.emit 'remove player', player

  setupPhysics: ->
    @physics = new Physics()
    # 
    @collision = new Collision()
    @bounds = new EdgeBounce new Vector(0,0), new Vector(@width, @height)
    @center = new Attraction()
    @center.target.x = @width/2
    @center.target.y = @height/2
    @center.strength = 120

    # add sample player
    @addPlayer({id:1000})

    @update()
    @gameState()

  destructor: ->
    @socket.server.close()

module.exports = Game
