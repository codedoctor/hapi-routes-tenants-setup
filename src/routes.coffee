_ = require 'underscore'
Boom = require 'boom'
Hoek = require "hoek"
bson = require 'bson'
ObjectID = bson.ObjectID
async = require 'async'

helperObjToRest = require './helper-obj-to-rest'
i18n = require './i18n'
validationSchemas = require './validation-schemas'

fnCreateObjectId = ->
  (new ObjectID()).toString()

fnToObjectId = (objIdAsString) ->
  try
    return (new ObjectID(objIdAsString)).toString()
  catch
    return null

module.exports = (plugin,options = {}) ->
  Hoek.assert options.routesBaseName,i18n.optionsRoutesBaseNameRequired
  Hoek.assert options.tags && _.isArray(options.tags),i18n.optionsTagsRequiredAndArray
  Hoek.assert options.descriptionTenantSetupPost, i18n.optionsDescriptionTenantSetupPostRequired

  hapiUserStoreMultiTenant = -> plugin.plugins['hapi-user-store-multi-tenant']
  Hoek.assert hapiUserStoreMultiTenant(),i18n.couldNotFindHapiUserStoreMultiTenantPlugin

  hapiOauthStoreMultiTenant = -> plugin.plugins['hapi-oauth-store-multi-tenant']
  Hoek.assert hapiUserStoreMultiTenant(),i18n.couldNotFindHapiOauthStoreMultiTenantPlugin

  methodsRoles = -> hapiUserStoreMultiTenant().methods.roles
  methodsUsers = -> hapiUserStoreMultiTenant().methods.users
  methodsOauthScopes = -> hapiOauthStoreMultiTenant().methods.oauthScopes
  methodsOauthApps = -> hapiOauthStoreMultiTenant().methods.oauthApps
  methodsOauthAuth = -> hapiOauthStoreMultiTenant().methods.oauthAuth

  Hoek.assert methodsRoles(),i18n.couldNotFindMethodsRoles
  Hoek.assert methodsUsers(),i18n.couldNotFindMethodsUsers
  Hoek.assert methodsOauthScopes(),i18n.couldNotFindMethodsOauthScopes
  Hoek.assert methodsOauthApps(),i18n.couldNotFindMethodsOauthApps
  Hoek.assert methodsOauthAuth(),i18n.couldNotFindMethodsOauthAuth


  plugin.route
    path: "#{options.routesBaseName}"
    method: "POST"
    config:
      description: options.descriptionTenantSetupPost
      tags: options.tags
      validate:
        payload: validationSchemas.payloadTenantSetupPost
    handler: (request, reply) ->
      return cb Boom.badRequest(i18n.errorAtLeastOneUserRequired) unless request.payload.users && _.isArray(request.payload.users) && request.payload.users.length > 0

      _tenantId = fnToObjectId(request.payload.tenantId) || fnCreateObjectId()
      clientId = fnToObjectId(request.payload.clientId) || fnCreateObjectId()

      appData = request.payload.app || {}

      appData._tenantId = _tenantId
      appData.clients = [
          clientId: clientId
        ]

      result = 
        _tenantId: _tenantId
        clientId: clientId

      fnCreateRole = (roleData,cb) ->
        methodsRoles().create _tenantId,roleData,null, cb

      fnCreateScope = (scopeData,cb) ->
        methodsOauthScopes().create _tenantId,scopeData,null, cb

      fnCreateUser = (userData,cb) ->
        methodsUsers().create _tenantId,userData,null,cb


      async.map request.payload.roles || [], fnCreateRole, (err,createdRoles) ->
        return reply err if err
        result.roles = _.map(createdRoles, helperObjToRest.role)

        async.map request.payload.scopes || [], fnCreateScope, (err,createdScopes) ->
          return reply err if err
          result.scopes = _.map(createdScopes, helperObjToRest.scope)

          async.map request.payload.users || [], fnCreateUser, (err,createdUsers) ->
            return reply err if err
            result.users = _.map(createdUsers, helperObjToRest.user)

            firstUserId = _.first(createdUsers)._id

            appData.createdByUserId = firstUserId
            appData.tosAcceptanceDate = new Date()

            methodsOauthApps().create _tenantId,appData, null, (err,createdApp) ->
              return reply err if err
              result.app = helperObjToRest.app(createdApp)


              fnCreateTokens = (userData,cb) ->
                methodsOauthAuth().createOrReuseTokenForUserId _tenantId,userData._id,clientId,null,null,null,cb

              async.map result.users, fnCreateTokens, (err,createdTokens) ->
                return reply err if err

                h = {}
                h[token.identityUserId.toString()] = token for token in createdTokens

                for user in result.users
                  user.token = helperObjToRest.token( h[user._id.toString()] )

                reply(result).code(201)

