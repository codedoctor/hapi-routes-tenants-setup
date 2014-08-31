

module.exports = 
  payloadValid: 
    secretKey: 'hello'
    tenantId: '01234567890123456789000b'
    clientId: '01234567890123456789000a'
    app:
      name : 'somename'
      websiteUrl: 'http://somesite.com'
      imageUrl: null
      callbackUrl: null
      notes: 'Some comment'
      newUserDefaultRoles: ['read','write']
      scopes: ['read','write','server-admin']
      description: ''
      acceptTermsOfService: true
      isPublished: true
      organizationName: 'someorg'
      organizationUrl: 'http://somesite.com'
      tosAcceptanceDate : null
      redirectUrls: []
    scopes: [
        name: 'read' 
        description: 'Allows this app to read your data.'
        developerDescription: 'Read access to the data'
        roles: []
      ,
        name: 'write' 
        description: 'Allows this app to write your data.'
        developerDescription: 'Write access to the data'
        roles: []
      ,
        name: 'server-admin' 
        description: 'Allows for the adminstration of the server.'
        developerDescription: 'Internal, only used within the platform'
        isInternal: true
        roles: ['server-admin']
      ]
    roles: [
          name: 'read'
          description: 'Read access to the site'
          isInternal: false
        ,
          name: 'write'
          description: 'Write access to the site'
          isInternal: false
        ,
          name: 'admin'
          description: 'Allows to administer your site'
          isInternal: false
        ,
          name: 'platform-admin'
          description: 'Gives full access to the platform'
          isInternal: true
      ]
    users: [
        username: 'user1'
        password: 'password1!'
        email: 'mail@emial.com'
        roles: ['read','write','admin','platform-admin']
      ,
        username: 'user2'
        password: 'password2!'
        email: 'mail1@emial.com'
        roles: ['read','write','admin']

    ]

  clientId:  '01234567890123456789000a'
  _tenantId: '01234567890123456789000b'

  invalidRoleId:'0123456789012345678900aa'

  credentialsUser:
    id: "13a88c31413019245de27da7"
    username: 'Martin Wawrusch'
    _tenantId: '13a88c31413019245de27da0'
    roles: []

  credentialsServerAdmin:
    id: "13a88c31413019245de27da0"
    username: 'John Smith'
    _tenantId: '13a88c31413019245de27da0'
    roles: []
    scopes: ['server-admin']
