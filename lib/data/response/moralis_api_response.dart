
import 'package:sing_app/utils/parse_util.dart';

abstract class BaseMoralisResponse {
  BaseMoralisResponse();

  BaseMoralisResponse.fromJson(Map<String, dynamic> json);

// BaseMoralisResponse.withError(CovalentError error);
}

// class DefaultMoralisResponse<T> extends BaseMoralisResponse {
//   T? result;
//   bool isError = false;
//   String? errorMessage;
//   int? errorCode;
//
//   DefaultCovalentResponse({
//     this.result,
//     this.isError = false,
//     this.errorMessage = '',
//     this.errorCode = 0,
//   });
//
//   DefaultCovalentResponse.fromJson(Map<dynamic, dynamic> json) {
//     if(json['error']){
//       isError = true;
//       errorMessage = json['error_message'];
//       errorCode = Parse.toIntValue(json['error_code']);
//     } else {
//       result = json['data'] as T;
//     }
//   }
//
// // DefaultCovalentResponse.withError(CovalentError err) {
// //   result = null;
// //   success = false;
// //   error = err;
// // }
//
// // Map<String, dynamic> toJson() {
// //   return {
// //     'result': result,
// //     'error': error
// //   };
// // }
// }

class MoralisPaginationResponse<T> extends BaseMoralisResponse {
  List<T>? result;

  int? page;
  int? pageSize;
  int? total;

  String? cursor;
  String? status;

  bool isError = false;
  String? errorMessage;

  MoralisPaginationResponse({
    this.result,
    this.page,
    this.pageSize,
    this.total,
    this.isError = false,
    this.errorMessage
  });

  MoralisPaginationResponse.fromJson(Map<dynamic, dynamic> json) {
    page = json['page'];
    pageSize = json['page_size'];
    total = json['total'];
    cursor = json['cursor'];
    status = json['status'];
    result = json['result'] ?? [];
  }
}


