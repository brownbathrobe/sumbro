class Game

  width: window.innerWidth
  height: window.innerHeight

  constructor: ->
    @setup()

  addPlayer: ->

  removePlayer: (id) ->

  setup: ->
    @physics = new Physics()
    @physics.integrator = new Verlet()
    @collision = new Collision()
    @bounds = new EdgeBounce new Vector(0,0), new Vector(@width, @height)

    @update()
    
    



  render: ->

  update: ->
    @physics.step()

game = new Game()

