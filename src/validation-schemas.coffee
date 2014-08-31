Joi = require "joi"
i18n = require "./i18n"

module.exports =

  payloadTenantSetupPost: Joi.object().keys().options({ allowUnkown: true, stripUnknown: false })

