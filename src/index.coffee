###
@author Martin Wawrusch (martin@wawrusch.com)
###

Hoek = require 'hoek'
i18n = require './i18n'
routes = require './routes'

###
Main entry point for the plugin

@param [Plugin] plugin the HAPI plugin
@param [Object] options the plugin options
@option options [String] routesBaseName the name of the endpoints, defaults to '/tenants/setup'.
@option options [Array] tags the tags applied to the route, defaults to 'identity' and 'role'. Can be an empty array.
@option options [String] descriptionTenantSetupPost the description for the POST /tenants/setup endpoint.

@param [Function] cb the callback invoked after completion

Please note that the routesBaseName is only included to make the life easier while doing the config of your HAPI server.
###
module.exports.register = (server, options = {}, cb) ->

  defaults =
    routesBaseName: '/tenants/setup'
    tags: ['setup','private']
    descriptionTenantSetupPost: i18n.descriptionTenantSetupPost

  options = Hoek.applyToDefaults defaults, options

  routes server,options

  server.expose 'i18n',i18n

  cb()

###
@nodoc
###
module.exports.register.attributes =
  pkg: require '../package.json'

