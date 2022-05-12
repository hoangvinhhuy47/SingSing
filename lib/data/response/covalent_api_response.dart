
import 'package:sing_app/utils/parse_util.dart';

abstract class BaseCovalentResponse {
  BaseCovalentResponse();

  BaseCovalentResponse.fromJson(Map<String, dynamic> json);

  // BaseCovalentResponse.withError(CovalentError error);
}

class DefaultCovalentResponse<T> extends BaseCovalentResponse {
  T? result;
  bool isError = false;
  String? errorMessage;
  int? errorCode;

  DefaultCovalentResponse({
    this.result,
    this.isError = false,
    this.errorMessage = '',
    this.errorCode = 0,
  });

  DefaultCovalentResponse.fromJson(Map<dynamic, dynamic> json) {
    if(json['error']){
      isError = true;
      errorMessage = json['error_message'];
      errorCode = Parse.toIntValue(json['error_code']);
    } else {
      result = json['data'] as T;
    }
  }

  // DefaultCovalentResponse.withError(CovalentError err) {
  //   result = null;
  //   success = false;
  //   error = err;
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'result': result,
  //     'error': error
  //   };
  // }
}

class CovalentPaginationResponse<T> extends BaseCovalentResponse {
  List<T>? data;

  int? pageNumber;
  int? pageSize;
  bool? hasMore;

  bool isError = false;
  String? errorMessage;
  int? errorCode;

  CovalentPaginationResponse({
    this.data,
    this.pageNumber,
    this.pageSize,
    this.hasMore,
    this.isError = false,
    this.errorMessage,
    this.errorCode
  });

  CovalentPaginationResponse.fromJson(Map<dynamic, dynamic> json) {
    if(json['error'] && json['error'] == true){
      isError = true;
      errorMessage = json['error_message'];
      errorCode = Parse.toIntValue(json['error_code']);
    } else {
      data = json['data']['items'] ?? [];
      if(json['data']['pagination'] != null) {
        hasMore = Parse.toBoolValue(json['data']['pagination']['has_more']);
        pageSize = Parse.toIntValue(json['data']['pagination']['page_size']);
        pageNumber = Parse.toIntValue(json['data']['pagination']['page_number']);
      }
    }
  }
}


