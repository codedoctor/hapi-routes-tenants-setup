(function() {
  var Boom, Hoek, ObjectID, async, bson, fnCreateObjectId, fnToObjectId, helperObjToRest, i18n, validationSchemas, _;

  _ = require('underscore');

  Boom = require('boom');

  Hoek = require("hoek");

  bson = require('bson');

  ObjectID = bson.ObjectID;

  async = require('async');

  helperObjToRest = require('./helper-obj-to-rest');

  i18n = require('./i18n');

  validationSchemas = require('./validation-schemas');

  fnCreateObjectId = function() {
    return (new ObjectID()).toString();
  };

  fnToObjectId = function(objIdAsString) {
    try {
      return (new ObjectID(objIdAsString)).toString();
    } catch (_error) {
      return null;
    }
  };

  module.exports = function(plugin, options) {
    var hapiOauthStoreMultiTenant, hapiUserStoreMultiTenant, methodsOauthApps, methodsOauthAuth, methodsOauthScopes, methodsRoles, methodsUsers;
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
    methodsOauthAuth = function() {
      return hapiOauthStoreMultiTenant().methods.oauthAuth;
    };
    Hoek.assert(methodsRoles(), i18n.couldNotFindMethodsRoles);
    Hoek.assert(methodsUsers(), i18n.couldNotFindMethodsUsers);
    Hoek.assert(methodsOauthScopes(), i18n.couldNotFindMethodsOauthScopes);
    Hoek.assert(methodsOauthApps(), i18n.couldNotFindMethodsOauthApps);
    Hoek.assert(methodsOauthAuth(), i18n.couldNotFindMethodsOauthAuth);
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
        var appData, clientId, fnCreateRole, fnCreateScope, fnCreateUser, result, _tenantId;
        if (!(request.payload.users && _.isArray(request.payload.users) && request.payload.users.length > 0)) {
          return cb(Boom.badRequest(i18n.errorAtLeastOneUserRequired));
        }
        _tenantId = fnToObjectId(request.payload.tenantId) || fnCreateObjectId();
        clientId = fnToObjectId(request.payload.clientId) || fnCreateObjectId();
        appData = request.payload.app || {};
        appData._tenantId = _tenantId;
        appData.clients = [
          {
            clientId: clientId
          }
        ];
        result = {
          _tenantId: _tenantId,
          clientId: clientId
        };
        fnCreateRole = function(roleData, cb) {
          return methodsRoles().create(_tenantId, roleData, null, cb);
        };
        fnCreateScope = function(scopeData, cb) {
          return methodsOauthScopes().create(_tenantId, scopeData, null, cb);
        };
        fnCreateUser = function(userData, cb) {
          return methodsUsers().create(_tenantId, userData, null, cb);
        };
        return async.map(request.payload.roles || [], fnCreateRole, function(err, createdRoles) {
          if (err) {
            return reply(err);
          }
          result.roles = _.map(createdRoles, helperObjToRest.role);
          return async.map(request.payload.scopes || [], fnCreateScope, function(err, createdScopes) {
            if (err) {
              return reply(err);
            }
            result.scopes = _.map(createdScopes, helperObjToRest.scope);
            return async.map(request.payload.users || [], fnCreateUser, function(err, createdUsers) {
              var firstUserId;
              if (err) {
                return reply(err);
              }
              result.users = _.map(createdUsers, helperObjToRest.user);
              firstUserId = _.first(createdUsers)._id;
              appData.createdByUserId = firstUserId;
              appData.tosAcceptanceDate = new Date();
              return methodsOauthApps().create(_tenantId, appData, null, function(err, createdApp) {
                var fnCreateTokens;
                if (err) {
                  return reply(err);
                }
                result.app = helperObjToRest.app(createdApp);
                fnCreateTokens = function(userData, cb) {
                  return methodsOauthAuth().createOrReuseTokenForUserId(_tenantId, userData._id, clientId, null, null, null, cb);
                };
                return async.map(result.users, fnCreateTokens, function(err, createdTokens) {
                  var h, token, user, _i, _j, _len, _len1, _ref;
                  if (err) {
                    return reply(err);
                  }
                  h = {};
                  for (_i = 0, _len = createdTokens.length; _i < _len; _i++) {
                    token = createdTokens[_i];
                    h[token.identityUserId.toString()] = token;
                  }
                  _ref = result.users;
                  for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
                    user = _ref[_j];
                    user.token = helperObjToRest.token(h[user._id.toString()]);
                  }
                  return reply(result).code(201);
                });
              });
            });
          });
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=routes.js.map
