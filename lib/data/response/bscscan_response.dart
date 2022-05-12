import 'dart:convert';

import 'package:sing_app/utils/parse_util.dart';

abstract class BaseBscScanResponse {
  BaseBscScanResponse();

  BaseBscScanResponse.fromJson(Map<String, dynamic> json);

// BaseCovalentResponse.withError(CovalentError error);
}

class DefaultBscScanResponse<T> extends BaseBscScanResponse {
  List<T>? result;
  String? status;
  String? message;

  DefaultBscScanResponse({
    this.result,
    this.status = '',
    this.message = '',
  });

  DefaultBscScanResponse.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['status'] == '1') {
      result = json['result']  ?? [];
    }
  }


}


