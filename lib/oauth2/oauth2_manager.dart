
import 'dart:convert';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/oauth2/oauth2_token.dart';
import 'package:sing_app/oauth2/oauth2_user_info.dart';
import 'package:http/http.dart' as http;
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/secure_storage_utils.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'oauth2_config.dart';
import 'oauth2_response.dart';

class Oauth2Manager {
  UserProfile? userInfo;
  Oauth2Token? token;
  String _codeVerifierLogin = '';
  String _codeVerifierRegistrations = '';

  static const userStorageKey = 'user';
  static const tokenStorageKey = 'token';
  static const oauth2UserIdStorageKey = 'oauth2UserId';


  // singleton object
  Oauth2Manager._privateConstructor();
  static final Oauth2Manager instance = Oauth2Manager._privateConstructor();


  String getUrlAuthorize() {
    String responseType = 'response_type=code';
    String clientId = 'client_id=${AppConfig.instance.values.authClientId}';
    String redirectUrl = 'redirect_uri=${AppConfig.instance.values.authRedirectSchema}${Oauth2Config.redirectUri}';

    var scopeList = Oauth2Config.authorizationScope.split(',');
    String scopeJoined = scopeList.join(',');

    String scope = 'scope=$scopeJoined';
    String state = 'state=${generateRandomString(20)}';
    String codeChallengeMethod = 'code_challenge_method=S256';

    _codeVerifierLogin = _createCodeVerifier();
    LoggerUtil.info('_codeVerifierLogin: $_codeVerifierLogin');
    var codeChallenge = 'code_challenge=' + base64Url.encode(sha256.convert(ascii.encode(_codeVerifierLogin)).bytes).replaceAll('=', '');

    String urlAuthorize = '${AppConfig.instance.values.authUrl}${Oauth2Config.authorizeUrl}?$responseType&$clientId&$redirectUrl&$scope&$state&$codeChallenge&$codeChallengeMethod';
    LoggerUtil.info('urlAuthorize: $urlAuthorize');
    return urlAuthorize;
  }

  String getUrlRegistration() {
    String responseType = 'response_type=code';
    String clientId = 'client_id=${AppConfig.instance.values.authClientId}';
    String redirectUrl = 'redirect_uri=${AppConfig.instance.values.authRedirectSchema}${Oauth2Config.redirectUri}';

    var scopeList = Oauth2Config.authorizationScope.split(',');
    String scopeJoined = scopeList.join(',');

    String scope = 'scope=$scopeJoined';
    String state = 'state=${generateRandomString(20)}';
    String codeChallengeMethod = 'code_challenge_method=S256';

    _codeVerifierRegistrations = _createCodeVerifier();
    var codeChallenge = 'code_challenge=' + base64Url.encode(sha256.convert(ascii.encode(_codeVerifierRegistrations)).bytes).replaceAll('=', '');

    String urlRegistraions = '${AppConfig.instance.values.authUrl}${Oauth2Config.registrationsUrl}?$responseType&$clientId&$redirectUrl&$scope&$state&$codeChallenge&$codeChallengeMethod';
    LoggerUtil.info('urlRegistraions: $urlRegistraions');
    return urlRegistraions;
  }

  String _createCodeVerifier() {
    const String _charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    return List.generate(128, (i) => _charset[Random.secure().nextInt(_charset.length)]).join();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  Future<void> doAuthLogin(String code, Function? onLoginResult,{ bool isRegistrations = false}) async{
    try {
      Map<String, String> header = <String, String>{
        'Connection' : 'keep-alive',
      };
      Map<String, String> body = <String, String>{
        'grant_type' : 'authorization_code',
        'client_id' : AppConfig.instance.values.authClientId,
        'redirect_uri' : '${AppConfig.instance.values.authRedirectSchema}${Oauth2Config.redirectUri}',
        'code' : code,
        'code_verifier' : isRegistrations ? _codeVerifierRegistrations : _codeVerifierLogin,
      };

      String errorMessage = '';
      final response = await http.post(
        Uri.parse('${AppConfig.instance.values.authUrl}${Oauth2Config.tokenUrl}'),
        headers: header,
        body: body,
      );

      if (response.statusCode == 200) {
        LoggerUtil.info('doAuth: success: ${response.body}');
        Oauth2Response oauth2 = Oauth2Response.fromJson(jsonDecode(response.body));

        if(oauth2.refreshToken?.isNotEmpty ?? false) { {
          token ??= Oauth2Token(accessToken: '', refreshToken: '');
          token!.refreshToken = oauth2.refreshToken!;
        }}

        if(oauth2.accessToken != null) {
          token ??= Oauth2Token(accessToken: '', refreshToken: '');
          token!.accessToken = oauth2.accessToken!;
          if(token!.accessToken.isNotEmpty){
            await storeToken(token!);
            // await getEndpointConfig(token!.accessToken);
            final userInfo = await getOauth2UserInfo(token!.accessToken);
            if(userInfo != null) {
              storeUserId(userInfo.sub);
            }
          }
        }
      } else {
        LoggerUtil.error('doAuth: error, ${response.body}');
        Map<String, dynamic> mError = jsonDecode(response.body);
        if(mError['error'] != null && mError['error_description'] != null) {
          dynamic message = mError['error_description']!;
          if(message is String) {
            errorMessage = message;
          }
        }
      }
      if(onLoginResult != null) {
        onLoginResult(token, errorMessage);
      }
    } catch (ex) {
      LoggerUtil.error('doAuth: error2, $ex');
      if(onLoginResult != null) {
        onLoginResult(token, ex.toString());
      }
    }
  }

  Future<Oauth2UserInfo?> getOauth2UserInfo(String accessToken) async{
    Map<String, String> header = <String, String>{};
    header['Authorization'] = 'Bearer ' + accessToken;
    // header['Content-type'] = 'application/json; charset=utf-8';
    // header['charset'] = 'utf-8';

    Map<String, String> body = <String, String>{};

    String url = '${AppConfig.instance.values.authUrl}${Oauth2Config.userInfoUrl}';
    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: body,
    );
    LoggerUtil.info('getOauth2UserInfo response: ${response.body}');
    if (response.statusCode == 200) {
      return Oauth2UserInfo.fromJson(jsonDecode(response.body));
    }
  }

  Future<Oauth2UserInfo?> getEndpointConfig(String accessToken) async{
    Map<String, String> header = <String, String>{
      'Authorization' : 'Bearer ' + accessToken,
    };
    Map<String, String> body = <String, String>{};

    final response = await http.get(
      Uri.parse('${AppConfig.instance.values.authUrl}${Oauth2Config.endpointConfig}'),
      headers: header,
    );

    if (response.statusCode == 200) {
      LoggerUtil.info('getEndpointConfig: ${response.body}');
      return Oauth2UserInfo.fromJson(jsonDecode(response.body));
    }
  }

  bool loggingOut = false;
  Future<bool> logout() async {
    if(loggingOut){
      return true;
    }
    loggingOut = true;
    if(token == null){
      await clearAllData();
      loggingOut = false;
      return true;
    }
    Map<String, String> header = <String, String>{
      'Authorization' : 'Bearer ' + token!.accessToken,
    };

    Map<String, String> body = <String, String>{
      'client_id' : AppConfig.instance.values.authClientId,
      'refresh_token' : token!.refreshToken,
    };

    final response = await http.post(
      Uri.parse('${AppConfig.instance.values.authUrl}${Oauth2Config.logoutUrl}'),
      headers: header,
      body: body,
    );

    await clearAllData();

    if (response.statusCode == 204) {
      LoggerUtil.info('Logout api success');
      loggingOut = false;
      return true;
    } else {
      LoggerUtil.error('Logout api error: $response');
      loggingOut = false;
      return false;
    }
  }

  Future<UserProfile?> getUser() async {
    if(userInfo != null){
      return userInfo;
    }
    final userJson = await SecureStorageUtil.shared.readData(userStorageKey);
    if (userJson != null) {
      userInfo = UserProfile.fromJson(jsonDecode(userJson));
    }
    return userInfo;
  }

  storeUser(UserProfile user) async {
    userInfo = user;
    final String userJson = jsonEncode(user);
    SecureStorageUtil.shared.writeData(userStorageKey, userJson);
  }

  _clearUser() async {
    userInfo = null;
    SecureStorageUtil.shared.deleteKey(userStorageKey);
  }

  Future<Oauth2Token?> getToken() async {
    if(token != null){
      return token;
    }
    final tokenJson = await SecureStorageUtil.shared.readData(tokenStorageKey);
    if (tokenJson != null) {
      token = Oauth2Token.fromJson(jsonDecode(tokenJson));
    }
    return token;
  }

  storeToken(Oauth2Token newToken) async {
    token = newToken;
    SecureStorageUtil.shared.writeData(tokenStorageKey, jsonEncode(token));
  }

  _clearToken() async {
    token = null;
    SecureStorageUtil.shared.deleteKey(tokenStorageKey);
  }

  // USER ID
  storeUserId(String userId) async {
    SecureStorageUtil.shared.writeData(oauth2UserIdStorageKey, userId);
  }

  _clearUserId() async {
    SecureStorageUtil.shared.deleteKey(oauth2UserIdStorageKey);
  }

  Future<String?> getUserId() async {
    return await SecureStorageUtil.shared.readData(oauth2UserIdStorageKey);
  }

  clearAllData() async {
    _clearUser();
    _clearToken();
    _clearUserId();
  }
}