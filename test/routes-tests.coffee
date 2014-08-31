assert = require 'assert'
should = require 'should'

fixtures = require './support/fixtures'
loadServer = require './support/load-server'

describe 'AN EMPTY DB', ->
  server = null

  describe 'with loaded setup', ->
    beforeEach (cb) ->
      loadServer (err,serverResult) ->
        server = serverResult
        cb err

    describe 'POST /tenants/setup', ->
      describe 'with VALID data', ->
        it 'should return a 401', (cb) ->
 
          options =
            method: "POST"
            credentials: null
            payload: fixtures.payloadValid
            url: '/tenants/setup'

          server.inject options, (response) ->
            response.statusCode.should.equal 201
            console.log JSON.stringify(response.result)
            cb null,response
