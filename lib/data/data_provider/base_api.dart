import 'package:dio/dio.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/root/root_event.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/localization_key.dart';
import 'package:sing_app/data/data_provider/api_manager.dart';
import 'package:sing_app/data/response/api_response.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/services/connectivity_service.dart';
import 'package:sing_app/utils/logger_util.dart';

class ErrorMessage {
  static const String headerErrorMessage = 'Failed to parse header value';
  static const String unauthorizedErrorMessage = 'Http status error [401]';
}

class BaseAPI {
  final String tag = 'BaseAPI';

  // INSTANTS
  final int receiveTimeout = 60000; // milliseconds
  final int connectTimeout = 60000; // milliseconds

  // PROPERTIES
  Dio _dio = Dio();
  late String _baseUrl ;
  late RootBloc _rootBloc;

  // INIT
  BaseAPI({
    required RootBloc rootBloc,
    required String baseUrl
  }) {
    _baseUrl = baseUrl;
    _rootBloc = rootBloc;

    final BaseOptions options = BaseOptions(
      receiveTimeout: receiveTimeout,
      connectTimeout: connectTimeout,
      baseUrl: _baseUrl,
    );

    _dio = Dio(options);
    if (!AppConfig.isProduction()) {
      _setupLoggingInterceptor();
    }
  }

  // FUNCTION
  Future<dynamic> request({
    required ApiManager manager,
    dynamic bodyParams,
    dynamic queryParams,
    String? optionalPath,
    bool isUseAccessToken = true,
  }) async {
    dynamic responseData;
    try {
      final ApiConfig config = manager.getConfig();

      // Check internet connection
      if ((await _checkInternetConnection()) == false) {
        return _errorJson(
          message: l(LocalizationKey.noInternetConnection),
        );
      }

      if (isUseAccessToken) {
        // // Check expired token
        // final bool isTokenExpired = await userRepository.isTokenExpired();
        // if (isTokenExpired) {
        //   _rootBloc.add(AccessTokenExpired());
        //   return null;
        // }
      }

      // Setup headers and token
      await _setAuthorizationHeader(
        config: config,
        isUseAccessToken: isUseAccessToken,
      );

      // Setup custom path
      final String path =
          optionalPath != null ? (config.path + optionalPath) : config.path;

      Response response;
      switch (config.method) {
        case HttpMethod.get:
          response = await _dio.get(path, queryParameters: queryParams ?? {});
          break;
        case HttpMethod.post:
          response = await _dio.post(path,
              data: bodyParams ?? {}, queryParameters: queryParams ?? {});
          break;
        case HttpMethod.put:
          response = await _dio.put(path,
              data: bodyParams ?? {}, queryParameters: queryParams ?? {});
          break;
        case HttpMethod.del:
          response = await _dio.delete(path,
              data: bodyParams ?? {}, queryParameters: queryParams ?? {});
          break;
      }
      responseData = response.data;
    } on DioError catch (exception) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.

      // Check for authorization error
      // if (isUseAccessToken) {
      //   if (_checkInvalidAuthorization(errorMessage: exception.message)) {
      //     _rootBloc.add(AccessTokenExpired());
      //     return null;
      //   }
      // }

      LoggerUtil.error('BaseAPI response error: ${manager.getConfig().path} - ${exception.response}');

      if (exception.response != null) {
        if (exception.response?.data is! String) {
          // final code = exception.response?.data['code'];
          // if(isUseAccessToken && code != null && code == 'invalid_or_expired_auth_token') {
          //   _rootBloc.add(AccessTokenExpired());
          //   return null;
          // }
          final code = exception.response?.data['error']['code'];
          if (isUseAccessToken && code != null && code == 401) {
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
    LoggerUtil.info('${manager.getConfig().method} - $_baseUrl${manager.getConfig().path} response: $responseData', tag: tag);
    return responseData;
  }

  void _setupLoggingInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          LoggerUtil.info('${options.method} ${options.uri}', tag: tag);

          if(options.headers.isNotEmpty) {
            LoggerUtil.info('Headers ${options.headers}', tag: tag);
          }

          if(options.method == 'GET' && options.queryParameters.isNotEmpty) {
            LoggerUtil.info('Query ${options.queryParameters}', tag: tag);
          }
          if(options.method == 'POST' && options.data != null) {
            LoggerUtil.info('Data ${options.data}', tag: tag);
          }
          // LoggerUtil.info('<-- END HTTP', tag: tag);

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

  Future<void> _setAuthorizationHeader({
    required ApiConfig config,
    required bool isUseAccessToken,
  }) async {
    _dio.options.headers = config.headers;
    final token = await Oauth2Manager.instance.getToken();
    if (token != null && isUseAccessToken) {
      _dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
  }

  Map<String, dynamic> _errorJson({
    int code = 0,
    String message = '',
  }) {
    return DefaultResponse(
      result: null,
      error: Error(message: message),
    ).toJson();
  }

  Future<bool> _checkInternetConnection() async {
    final ConnectivityService service = ConnectivityService();
    return service.hasConnection();
  }

  // bool _checkInvalidAuthorization({@required String errorMessage}) {
  //   return errorMessage.contains(ErrorMessage.headerErrorMessage) ||
  //       errorMessage.contains(ErrorMessage.unauthorizedErrorMessage);
  // }
}
