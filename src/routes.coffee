_ = require 'underscore'
Boom = require 'boom'
Hoek = require "hoek"

helperObjToRest = require './helper-obj-to-rest'
i18n = require './i18n'
validationSchemas = require './validation-schemas'

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
  methodsOauthAdmin = -> hapiOauthStoreMultiTenant().methods.admin
  
  Hoek.assert methodsRoles(),i18n.couldNotFindMethodsRoles
  Hoek.assert methodsUsers(),i18n.couldNotFindMethodsUsers
  Hoek.assert methodsOauthScopes(),i18n.couldNotFindMethodsOauthScopes
  Hoek.assert methodsOauthApps(),i18n.couldNotFindMethodsOauthApps
  Hoek.assert methodsOauthAdmin(),i18n.couldNotFindMethodsOauthAdmin


  plugin.route
    path: "#{options.routesBaseName}"
    method: "POST"
    config:
      description: options.descriptionTenantSetupPost
      tags: options.tags
      validate:
        payload: validationSchemas.payloadTenantSetupPost
    handler: (request, reply) ->
      reply({}).code(201)

