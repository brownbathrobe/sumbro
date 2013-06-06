class Player

  constructor: ({@x, @y, @z, @name}) ->

  toJSON: ->
    x: @x
    y: @y
    z: @z
    name: @name

module.exports = Player
