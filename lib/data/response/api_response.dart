import 'package:sing_app/constants/api_key_param.dart';

abstract class BaseResponse {
  BaseResponse();

  BaseResponse.fromJson(Map<String, dynamic> json);

  BaseResponse.withError(Error error);
}

class DefaultResponse<T> extends BaseResponse {
  T? result;
  Error? error;

  DefaultResponse({
    required this.result,
    required this.error,
  });

  DefaultResponse.fromJson(Map<String, dynamic> json) {
    result = json[ApiKeyParam.result] as T;
    error = (json[ApiKeyParam.error] != null) ? Error.fromJson(json[ApiKeyParam.error]) : null;
  }

  DefaultResponse.withError(Error err) {
    result = null;
    error = err;
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'error': error?.toJson(),
    };
  }
}

class PaginatorResponse<T> extends BaseResponse {
  late List<T> result;
  Error? error;
  Pagination? pagination;

  PaginatorResponse({
    required this.result,
    required this.error,
    required this.pagination,
  });

  PaginatorResponse.fromJson(Map<String, dynamic> json) {
    result = json[ApiKeyParam.result] ?? [];
    error = (json[ApiKeyParam.error] != null) ? Error.fromJson(json[ApiKeyParam.error]) : null;
    pagination = (json[ApiKeyParam.pagination] != null)
        ? Pagination.fromJson(json[ApiKeyParam.pagination])
        : null;
  }

  PaginatorResponse.withError(Error error) {
    result = [];
    error = error;
  }
}

class Error {
  String message = '';
  int code = 0;

  Error({
    required this.message,
    this.code = 0,
  });

  Error.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    code = json['code'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
    };
  }
}

class Pagination {
  int pageCurrent = 0;
  int pageLimit = 0;
  int totalPage = 0;
  int totalRecord = 0;

  Pagination.empty() {
    pageCurrent = 0;
    pageLimit = 0;
    totalPage = 0;
    totalRecord = 0;
  }

  Pagination.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      pageCurrent = json['page_current'] as int;
      pageLimit = json['page_limit'] as int;
      totalPage = json['total_page'] as int;
      totalRecord = json['total_record'] as int;
    } else {
      pageCurrent = 0;
      pageLimit = 0;
      totalPage = 0;
      totalRecord = 0;
    }
  }
}
