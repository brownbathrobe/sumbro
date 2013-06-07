class Game

  width: window.innerWidth
  height: window.innerHeight
  particlesize: 40
  colors:[
    'red',
    'blue',
    'green',
    'orange',
    'navy',
    'lime'
    ]

  initialize: ->
    @setup()

  render: ->
    for player in @physics.particles
      player.el.css
        top: player.pos.y
        left: player.pos.x

    setTimeout =>
      @update()
    , 17

  update: ->
    @physics.step()
    @render()

  addPlayer: ->
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
    @physics.particles.push player


  removePlayer: (id) ->

  setup: ->
    @physics = new Physics()
    @physics.integrator = new Verlet()
    
    @collision = new Collision()
    @bounds = new EdgeBounce new Vector(0,0), new Vector(@width, @height)
    @center = new Attraction()
    @center.target.x = @width/2
    @center.target.y = @height/2
    @center.strength = 120

    for i in [0..10]
      @addPlayer()

    console.log @
    @update()

game = new Game()
game.initialize()

