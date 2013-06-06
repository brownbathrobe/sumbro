Application = require '../../src/app/application.coffee'

describe 'Application', ->

  it 'can be required', ->
    app = new Application
    app.should.be.OK
