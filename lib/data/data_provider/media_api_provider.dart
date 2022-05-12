import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sing_app/data/data_provider/api_manager.dart';
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/response/ss_response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path_manager;
import 'package:sing_app/utils/logger_util.dart';

class MediaApiProvider {
  late BaseAPI _baseAPI;

  MediaApiProvider(BaseAPI baseAPI) {
    _baseAPI = baseAPI;
  }

  Future<DefaultSsResponse> uploadAvatar({
    required File file,
    required String mimeType
  }) async {
    try {
      final fileType = mimeType.split('/');
      final FormData formData = FormData.fromMap(
        {
          'file': await MultipartFile.fromFile(
            file.path,
            filename: path_manager.basename(file.path),
            contentType: fileType.length >= 2 ? MediaType(fileType[0], fileType[1]) : MediaType('',''),
          ),
        },
      );

      // if(fileType.length >= 2) {
      //   return DefaultWalletResponse.withError(
      //     WalletError(message: l('File size is less than 2MB')),
      //   );
      // }

      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.uploadAvatar),
        bodyParams: formData,
      );

      LoggerUtil.info('upload avatar res: $responseJson');
      final response = DefaultSsResponse.fromMap(responseJson);
      return response;
    } catch (exception) {
      LoggerUtil.info('upload avatar res error: $exception');
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

}