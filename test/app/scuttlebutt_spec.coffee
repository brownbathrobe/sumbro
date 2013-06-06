# spiking with scuttlebutt
sinon = require 'sinon'
net = require 'net'
Scuttlebutt = require 'scuttlebutt'
Model = require 'scuttlebutt/model'
http = require 'http'

describe 'scuttlebutt', ->

  it 'can be required', ->
    Scuttlebutt.should.be.OK

  it 'should have a model', ->
    Model.should.be.OK

  it 'can update and listen to a model', ->
    clock = sinon.useFakeTimers()
    m = new Model
    m.set 'count', 0
    spy = sinon.spy()
    m.on 'update', spy
    setInterval ->
      m.set "count", Number m.get("count") + 1
    , 320

    clock.tick 320
    spy.args[0][0].should.eql ['count', 1]
    spy.called.should.be.OK
    clock.tick 320
    spy.args[1][0].should.eql ['count', 2]

  it 'can update and listen to a stream', (done) ->
    clock = sinon.useFakeTimers()
    m = new Model

    server = net.createServer (stream) ->
      stream.pipe(m.createStream()).pipe stream

    server.listen(8888)

    m.on 'update', ->
      console.log 'arguments', arguments

    m.set 'count', 0

    setInterval ->
      m.set "count", Number m.get("count") + 1
    , 320

    clock.tick 320
    clock.tick 320
