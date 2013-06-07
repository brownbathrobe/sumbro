_ = require 'underscore'
io = require 'socket.io'
socket = io.listen(8000)
require '../../vendor/physics'

class Game

  width: 100
  height: 100
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
    player.el = ($ "<div class='ball user'/>")
    color = @colors[parseInt(Math.random()*@colors.length)]
    x = Math.random()*@width
    y = Math.random()*@height
    player.moveTo new Vector x, y
    player.el.css
      background: color
      width: @particlesize
      height: @particlesize

    
    $('body').prepend player.el
    
    @collision.pool.push player
    player.behaviours.push @collision, @bounds, @center
    @physics.particles.push playerup: ->

  update: ->
    @physics.step()
    setTimeout =>
      @update()
    , 15

  removePlayer: (player) =>
    delete @players[player.id]
    @socket.sockets.emit 'remove player', player

  setupPhysics: ->
    @physics = new Physics()
    @physics.integrator = new Verlet()
    
    @collision = new Collision()
    @bounds = new EdgeBounce new Vector(0,0), new Vector(@width, @height)
    @center = new Attraction()
    @center.target.x = @width/2
    @center.target.y = @height/2
    @center.strength = 120

    # add sample player
    @addPlayer()

    @update()

  destructor: ->
    @socket.server.close()

module.exports = Game
