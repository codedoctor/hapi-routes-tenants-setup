(function() {
  var Joi, i18n;

  Joi = require("joi");

  i18n = require("./i18n");

  module.exports = {
    payloadTenantSetupPost: Joi.object().keys().options({
      allowUnkown: true,
      stripUnknown: false
    })
  };

}).call(this);

//# sourceMappingURL=validation-schemas.js.map
