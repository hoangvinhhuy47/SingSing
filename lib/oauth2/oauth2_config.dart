
class Oauth2Config {
  static const String redirectUri = '://oauth2redirect';
  static const String authorizationScope = 'openid'; // use ','
  static const String authorizeUrl = '/realms/SingSing/protocol/openid-connect/auth';
  static const String registrationsUrl = '/realms/SingSing/protocol/openid-connect/registrations';
  static const String tokenUrl = '/realms/SingSing/protocol/openid-connect/token';
  static const String userInfoUrl = '/realms/SingSing/protocol/openid-connect/userinfo';
  static const String logoutUrl = '/realms/SingSing/protocol/openid-connect/logout';
  static const String endpointConfig = '/realms/SingSing/.well-known/openid-configuration';
}