(function() {
  var _;

  _ = require('underscore');

  module.exports = {
    scope: function(x) {
      x = JSON.parse(JSON.stringify(x));
      delete x.__v;
      return x;
    },
    role: function(x) {
      x = JSON.parse(JSON.stringify(x));
      delete x.__v;
      return x;
    },
    user: function(x) {
      x = JSON.parse(JSON.stringify(x));
      delete x.__v;
      delete x.password;
      return x;
    },
    app: function(x) {
      x = JSON.parse(JSON.stringify(x));
      delete x.__v;
      return x;
    },
    token: function(x) {
      x = JSON.parse(JSON.stringify(x));
      x.accessToken = x._id;
      delete x.__v;
      delete x.createdAt;
      delete x.updatedAt;
      delete x._id;
      delete x._tenantId;
      delete x.appId;
      delete x.identityUserId;
      delete x.realm;
      return x;
    }
  };

}).call(this);

//# sourceMappingURL=helper-obj-to-rest.js.map
