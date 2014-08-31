_ = require 'underscore'

module.exports = 
  scope: (x) ->
    x = JSON.parse(JSON.stringify(x))
    delete x.__v
    x

  role: (x) ->
    x = JSON.parse(JSON.stringify(x))
    delete x.__v
    x

  user: (x) ->
    x = JSON.parse(JSON.stringify(x))
    delete x.__v
    delete x.password
    x

  app: (x) ->
    x = JSON.parse(JSON.stringify(x))
    delete x.__v
    x

  token: (x) ->
    x = JSON.parse(JSON.stringify(x))
    x.accessToken = x._id

    delete x.__v
    delete x.createdAt
    delete x.updatedAt
    delete x._id
    delete x._tenantId
    delete x.appId
    delete x.identityUserId
    delete x.realm
    x
