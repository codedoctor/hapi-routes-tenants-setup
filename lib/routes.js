(function() {
  var Boom, Hoek, helperObjToRest, i18n, validationSchemas, _;

  _ = require('underscore');

  Boom = require('boom');

  Hoek = require("hoek");

  helperObjToRest = require('./helper-obj-to-rest');

  i18n = require('./i18n');

  validationSchemas = require('./validation-schemas');

  module.exports = function(plugin, options) {
    var hapiOauthStoreMultiTenant, hapiUserStoreMultiTenant, methodsOauthAdmin, methodsOauthApps, methodsOauthScopes, methodsRoles, methodsUsers;
    if (options == null) {
      options = {};
    }
    Hoek.assert(options.routesBaseName, i18n.optionsRoutesBaseNameRequired);
    Hoek.assert(options.tags && _.isArray(options.tags), i18n.optionsTagsRequiredAndArray);
    Hoek.assert(options.descriptionTenantSetupPost, i18n.optionsDescriptionTenantSetupPostRequired);
    hapiUserStoreMultiTenant = function() {
      return plugin.plugins['hapi-user-store-multi-tenant'];
    };
    Hoek.assert(hapiUserStoreMultiTenant(), i18n.couldNotFindHapiUserStoreMultiTenantPlugin);
    hapiOauthStoreMultiTenant = function() {
      return plugin.plugins['hapi-oauth-store-multi-tenant'];
    };
    Hoek.assert(hapiUserStoreMultiTenant(), i18n.couldNotFindHapiOauthStoreMultiTenantPlugin);
    methodsRoles = function() {
      return hapiUserStoreMultiTenant().methods.roles;
    };
    methodsUsers = function() {
      return hapiUserStoreMultiTenant().methods.users;
    };
    methodsOauthScopes = function() {
      return hapiOauthStoreMultiTenant().methods.oauthScopes;
    };
    methodsOauthApps = function() {
      return hapiOauthStoreMultiTenant().methods.oauthApps;
    };
    methodsOauthAdmin = function() {
      return hapiOauthStoreMultiTenant().methods.admin;
    };
    Hoek.assert(methodsRoles(), i18n.couldNotFindMethodsRoles);
    Hoek.assert(methodsUsers(), i18n.couldNotFindMethodsUsers);
    Hoek.assert(methodsOauthScopes(), i18n.couldNotFindMethodsOauthScopes);
    Hoek.assert(methodsOauthApps(), i18n.couldNotFindMethodsOauthApps);
    Hoek.assert(methodsOauthAdmin(), i18n.couldNotFindMethodsOauthAdmin);
    return plugin.route({
      path: "" + options.routesBaseName,
      method: "POST",
      config: {
        description: options.descriptionTenantSetupPost,
        tags: options.tags,
        validate: {
          payload: validationSchemas.payloadTenantSetupPost
        }
      },
      handler: function(request, reply) {
        return reply({}).code(201);
      }
    });
  };

}).call(this);

//# sourceMappingURL=routes.js.map
