import 'package:sing_app/constants/api_key_param.dart';
import 'package:sing_app/utils/logger_util.dart';

abstract class SsResponse {
  SsResponse();

  SsResponse.fromMap(Map<dynamic, dynamic> json);

  SsResponse.withError(int errorCode, String message);
}

class DefaultSsResponse<T> extends SsResponse {
  T? data;
  SsError? error;
  bool success = true;

  DefaultSsResponse({
    this.data,
    this.error,
    this.success = true,
  });

  DefaultSsResponse.fromMap(Map<dynamic, dynamic> json) {
    if(json[ApiKeyParam.success] != null) {
      success = json[ApiKeyParam.success];
    }

    if(json[ApiKeyParam.error] != null){
      error = SsError.fromJson(json[ApiKeyParam.error]);
    }

    if(json[ApiKeyParam.data] != null){
      data = json[ApiKeyParam.data] as T;
    }
  }

  DefaultSsResponse.withError(SsError err) {
    data = null;
    success = false;
    error = err;
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'error': error?.toJson(),
    };
  }
}

class PaginatorSsResponse<T> extends SsResponse {
  late List<T>? data;
  SsError? error;
  bool success = true;
  Pagination? pagination;

  PaginatorSsResponse({
    this.data,
    this.error,
    this.success = true,
    this.pagination,
  });

  PaginatorSsResponse.fromMap(Map<dynamic, dynamic> json) {
    if(json[ApiKeyParam.error] != null){
      success = false;
      error = SsError(message: json[ApiKeyParam.error]);
    } else {
      success = true;
      data = json[ApiKeyParam.data] ?? [];
      pagination = Pagination.fromJson(json[ApiKeyParam.pagination]);
    }

  }

  PaginatorSsResponse.withError(SsError err) {
    data = null;
    success = false;
    error = err;
  }

}


class Pagination {
  int total = 0;
  int offset = 0;
  int limit = 0;

  Pagination({
    this.total = 0,
    this.offset = 0,
    this.limit = 0,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    offset = json['offset'] ?? 0;
    limit = json['limit'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'offset': offset,
      'limit' : limit
    };
  }
}

class SsError {
  String message = '';
  int code = 0;

  SsError({
    this.message = '',
    this.code = 0,
  });

  SsError.fromJson(Map<String, dynamic> json) {
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