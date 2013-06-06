Player = require '../../src/app/player.coffee'

describe 'Player', ->

  it 'can be required', ->
    Player.should.be.a.function

  it 'should have a starting position', ->
    player = new Player
      x: 0, y: 0, z: 0

    player.x.should.equal 0
    player.y.should.equal 0
    player.z.should.equal 0

  it 'should have a name', ->
    player = new Player name: 'me'
    player.name.should.equal 'me'

  it 'can serialze its data', ->
    player = new Player
      x: 0, y: 0, z: 0, name: 'bob'
    player.toJSON().should.eql x: 0, y: 0, z: 0, name: 'bob'
