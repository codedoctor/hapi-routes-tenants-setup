[![Build Status](https://travis-ci.org/codedoctor/hapi-routes-tenants-setup.svg?branch=master)](https://travis-ci.org/codedoctor/hapi-routes-tenants-setup)
[![Coverage Status](https://img.shields.io/coveralls/codedoctor/hapi-routes-tenants-setup.svg)](https://coveralls.io/r/codedoctor/hapi-routes-tenants-setup)
[![NPM Version](http://img.shields.io/npm/v/hapi-routes-tenants-setup.svg)](https://www.npmjs.org/package//hapi-routes-tenants-setup)
[![Dependency Status](https://gemnasium.com/codedoctor/hapi-routes-tenants-setup.svg)](https://gemnasium.com/codedoctor/hapi-routes-tenants-setup)
[![NPM Downloads](http://img.shields.io/npm/dm/hapi-routes-tenants-setup.svg)](https://www.npmjs.org/package/hapi-routes-tenants-setup)
[![Issues](http://img.shields.io/github/issues/codedoctor/hapi-routes-tenants-setup.svg)](https://github.com/codedoctor/hapi-routes-tenants-setup/issues)
[![HAPI 8.0](http://img.shields.io/badge/hapi-8.0-blue.svg)](http://hapijs.com)
[![API Documentation](http://img.shields.io/badge/API-Documentation-ff69b4.svg)](http://coffeedoc.info/github/codedoctor/hapi-routes-tenants-setup)

(C) 2014 Martin Wawrusch

Provides an enpoint to set up a tenant with

* initial users
* oauth scopes
* roles
* a default oauth app + client
* tokens for your users

Basically, this allows you to bootstrap an installation using the codedoctor libraries by providing a /tenants/setup endpoint that you can post to.

Take a look at the [samples/sample.json](https://github.com/codedoctor/hapi-routes-tenants-setup/blob/master/samples/sample.json) file, which contains the typical sample data. Both
tenantId and clientId are optional. The file [samples/result.json](https://github.com/codedoctor/hapi-routes-tenants-setup/blob/master/samples/result.json) shows you the result of posting the sample.json file.


## How to secure this

Several easy options:

* Only include it when you run it for the first time, then remove it.
* supply a secret key, which must be included as the payload (secretKey). Something like so:

```coffeescript
hapiRoutesTenantsSetup = require 'hapi-routes-tenants-setup'

...

server = new Hapi.Server config.server.port, config.server.host,serverOptions

pluginConf = [
  ...
  ,
    plugin: hapiRoutesTenantsSetup
    options:
      secretKey: process.env.HAPIROUTESTENANTSETUPSECRETKEY
]

server.pack.register pluginConf, (err) ->
  throw err if err
  ...
```

You then set the env variable HAPIROUTESTENANTSETUPSECRETKEY at your server.

## How to post from curl

```bash
curl -H "Content-Type: application/json" -X POST -d @samples/sample.json https://yoursite.com/tenants/setup
```




## Dependencies

* HAPI >= 8.0.0,hapi-oauth-store-multi-tenant,hapi-user-store-multi-tenant

## Plugins that must be loaded into your hapi server:

* hapi-oauth-store-multi-tenant
* hapi-user-store-multi-tenant

## See also

* [hapi-auth-bearer-mw](https://github.com/codedoctor/hapi-auth-bearer-mw)
* [hapi-loggly](https://github.com/codedoctor/hapi-loggly)
* [hapi-mandrill](https://github.com/codedoctor/hapi-mandrill)
* [hapi-mongoose-db-connector](https://github.com/codedoctor/hapi-mongoose-db-connector)
* [hapi-oauth-store-multi-tenant](https://github.com/codedoctor/hapi-oauth-store-multi-tenant)
* [hapi-routes-authorization-and-session-management](https://github.com/codedoctor/hapi-routes-authorization-and-session-management)
* [hapi-routes-oauth-management](https://github.com/codedoctor/hapi-routes-oauth-management)
* [hapi-routes-tenants-setup](https://github.com/codedoctor/hapi-routes-tenants-setup)
* [hapi-routes-status](https://github.com/codedoctor/hapi-routes-status)
* [hapi-routes-users-authorizations](https://github.com/codedoctor/hapi-routes-users-authorizations)
* [hapi-routes-users](https://github.com/codedoctor/hapi-routes-users)
* [hapi-user-store-multi-tenant](https://github.com/codedoctor/hapi-user-store-multi-tenant)

and additionally

* [api-pagination](https://github.com/codedoctor/api-pagination)
* [mongoose-oauth-store-multi-tenant](https://github.com/codedoctor/mongoose-oauth-store-multi-tenant)
* [mongoose-rest-helper](https://github.com/codedoctor/mongoose-rest-helper)
* [mongoose-user-store-multi-tenant](https://github.com/codedoctor/mongoose-user-store-multi-tenant)

## Contributing
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the package.json, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Martin Wawrusch 


