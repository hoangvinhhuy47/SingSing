

import 'package:dio/dio.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/root/root_event.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/response/ss_response.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/services/connectivity_service.dart';
import 'package:sing_app/utils/logger_util.dart';

class SsAPI {
  final String tag = 'SsAPI';

  Map<String, String> get _defaultHeaders {
    return {'Content-Type': 'application/json'};
  }

  // INSTANTS
  final int receiveTimeout = 60000; // milliseconds
  final int connectTimeout = 60000; // milliseconds

  // PROPERTIES
  Dio _dio = Dio();
  late RootBloc _rootBloc;

  // INIT
  SsAPI({
    required RootBloc rootBloc,
  }) {
    _rootBloc = rootBloc;

    final BaseOptions options = BaseOptions(
      receiveTimeout: receiveTimeout,
      connectTimeout: connectTimeout,
      headers: _defaultHeaders
    );

    _dio = Dio(options);
    if (!AppConfig.isProduction()) {
      _setupLoggingInterceptor();
    }
  }

  // FUNCTION
  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    bool isUseAccessToken = false,
  }) async {
    Response responseData;
    try {
      if ((await _checkInternetConnection()) == false) {
        return _errorJson(message: l('error_noInternetConnection'));
      }
      await _setHeaders(headers, isUseAccessToken);
      responseData = await _dio.get(url, queryParameters: params ?? {});
      // LoggerUtil.info('$url response: $responseData', tag: tag);
      return responseData.data;
    } on DioError catch (exception) {
      LoggerUtil.error('BaseAPI response error: $url - ${exception.response}');

      if (exception.response != null) {
        if (exception.response?.data is! String) {
          final code = exception.response?.data['code'];
          if(isUseAccessToken && code != null && code == 'invalid_or_expired_auth_token') {
            _rootBloc.add(AccessTokenExpired());
            return null;
          }
          return exception.response?.data;
        } else {
          return _errorJson(
            code: exception.response?.statusCode ?? 400,
            message: exception.response?.data,
          );
        }
      }
      return _errorJson(
        message: exception.message,
      );
    }
  }

  // FUNCTION
  Future<dynamic> put({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    bool isUseAccessToken = false,
  }) async {
    Response responseData;
    try {
      if ((await _checkInternetConnection()) == false) {
        return _errorJson(message: l('error_noInternetConnection'));
      }
      await _setHeaders(headers, isUseAccessToken);
      responseData = await _dio.put(url, data: params ?? {});
      LoggerUtil.info('PUT $url response headers: ${responseData.headers} - data: ${responseData.data}', tag: tag);
      return responseData.data;
    } on DioError catch (exception) {
      LoggerUtil.error('BaseAPI response error: $url - ${exception.response}');

      if (exception.response != null) {
        if (exception.response?.data is! String) {
          final code = exception.response?.data['code'];
          if(isUseAccessToken && code != null && code == 'invalid_or_expired_auth_token') {
            _rootBloc.add(AccessTokenExpired());
            return null;
          }
          return exception.response?.data;
        } else {
          return _errorJson(
            code: exception.response?.statusCode ?? 400,
            message: exception.response?.data,
          );
        }
      }
      return _errorJson(
        message: exception.message,
      );
    }
  }

  Future<dynamic> post({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    bool isUseAccessToken = true,
  }) async {
    Response responseData;
    try {
      if ((await _checkInternetConnection()) == false) {
        return _errorJson(message: l('error_noInternetConnection'));
      }
      await _setHeaders(headers, isUseAccessToken);
      responseData = await _dio.post(url, data: params ?? {});
      // LoggerUtil.info('$url response: $responseData', tag: tag);
      return responseData.data;
    } on DioError catch (exception) {
      LoggerUtil.error('BaseAPI response error: $url - ${exception.response}');

      if (exception.response != null) {
        if (exception.response?.data is! String) {
          final code = exception.response?.data['code'];
          if(isUseAccessToken && code != null && code == 'invalid_or_expired_auth_token') {
            _rootBloc.add(AccessTokenExpired());
            return null;
          }
          return exception.response?.data;
        } else {
          return _errorJson(
            code: exception.response?.statusCode ?? 400,
            message: exception.response?.data,
          );
        }
      }
      return _errorJson(
        message: exception.message,
      );
    }
  }

  _setHeaders(Map<String, dynamic>? headers, bool isUseAccessToken) async {
    Map<String, dynamic> allHeaders = {};
    allHeaders.addAll(_defaultHeaders);
    if(headers != null) allHeaders.addAll(headers);
    if(isUseAccessToken) {
      final token = await Oauth2Manager.instance.getToken();
      if(token != null) allHeaders['Authorization'] = 'Bearer ${token.accessToken}';
    }
    _dio.options.headers = allHeaders;
  }

  void _setupLoggingInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          LoggerUtil.info('${options.method} ${options.uri}', tag: tag);

          if(options.headers.isNotEmpty) {
            LoggerUtil.info('Headers ${options.headers}', tag: tag);
          }

          // if(options.method == 'GET' && options.queryParameters.isNotEmpty) {
          //   LoggerUtil.info('Query ${options.queryParameters}', tag: tag);
          // }
          if(options.method == 'POST' && options.data != null) {
            LoggerUtil.info('Data ${options.data}', tag: tag);
          }

          return handler.next(options); //continue
        },
        onResponse: (response, handler) {
          return handler.next(response); // continue
        },
        onError: (DioError error, handler) {
          return handler.next(error); //continue
        },
      ),
    );
  }

  Map<String, dynamic> _errorJson({
    int code = 0,
    String message = '',
  }) {
    return DefaultSsResponse(
      data: null,
      error: SsError(message: message),
    ).toJson();
  }

  Future<bool> _checkInternetConnection() async {
    final ConnectivityService service = ConnectivityService();
    return service.hasConnection();
  }
}