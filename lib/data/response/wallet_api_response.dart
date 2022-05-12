//
// import 'package:sing_app/data/models/token_price.dart';
//
// abstract class BaseWalletResponse {
//   BaseWalletResponse();
//
//   BaseWalletResponse.fromJson(Map<String, dynamic> json);
//
//   BaseWalletResponse.withError(WalletError error);
// }
//
// class DefaultWalletResponse<T> extends BaseWalletResponse {
//   T? data;
//   List<WalletError>? errors;
//   bool success = true;
//
//   DefaultWalletResponse({
//     this.result,
//     this.errors,
//     this.success = true,
//   });
//
//   DefaultWalletResponse.fromJson(Map<dynamic, dynamic> json) {
//     if(json['errors'] != null){
//       success = false;
//       errors = [];
//
//       if(json['errors'] is String) {
//         final error = WalletError(message: json['errors']);
//         errors!.add(error);
//       } else {
//         for (final itemJson in json['errors'] ?? []) {
//           final error = WalletError.fromJson(itemJson);
//           errors!.add(error);
//         }
//       }
//     } else {
//       success = success = json['success'] ?? true;
//     }
//     if(success) {
//       if(json['result'] != null){
//         result = json['result'] as T;
//       } else {
//         result = json as T;
//       }
//     }
//   }
//
//   DefaultWalletResponse.withErrors(List<WalletError> err) {
//     result = null;
//     errors = err;
//     success = false;
//   }
//
//   DefaultWalletResponse.withError(WalletError err) {
//     result = null;
//     success = false;
//     final List<WalletError> _errors = [];
//     _errors.add(err);
//     errors = _errors;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'result': result,
//       'error': errors?.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class WalletPaginationResponse<T> extends BaseWalletResponse {
//   late List<T> data;
//   List<WalletError>? errors;
//   bool success = false;
//   int total = 0;
//   int page = 1;
//
//   WalletPaginationResponse({
//     required this.data,
//     required this.errors,
//     this.success = true,
//     this.total = 0,
//     this.page = 1,
//   });
//
//   WalletPaginationResponse.fromJson(Map<dynamic, dynamic> json) {
//     data = json['data'] ?? [];
//     total = json['total'] ?? 0;
//     page = json['page'] ?? 1;
//     success = true;
//     if(json['errors'] != null){
//       errors = [];
//       for (final itemJson in json['errors'] ?? []) {
//         final error = WalletError.fromJson(itemJson);
//         errors!.add(error);
//       }
//       success = false;
//     }
//   }
//
//   WalletPaginationResponse.withErrors(List<WalletError> err) {
//     data = [];
//     errors = err;
//     success = false;
//   }
//
//   WalletPaginationResponse.withError(WalletError err) {
//     data = [];
//     success = false;
//     final List<WalletError> _errors = [];
//     _errors.add(err);
//     errors = _errors;
//   }
// }
//
// class WalletError {
//   String message = '';
//   int code = 0;
//
//   WalletError({
//     this.message = '',
//     this.code = 0,
//   });
//
//   WalletError.fromJson(Map<String, dynamic> json) {
//     message = json['message'] ?? '';
//     code = json['code'] ?? 0;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'code': code,
//     };
//   }
// }
//
// class WalletTokenPriceResponse extends BaseWalletResponse {
//   TokenPrice? result;
//   WalletError? error;
//
//   WalletTokenPriceResponse({
//     required this.result,
//     this.error,
//   });
//
//   WalletTokenPriceResponse.fromJson(Map<dynamic, dynamic> json) {
//     if(json['code'] != null){
//       error = WalletError(message: json['msg'], code: json['code']);
//     } else {
//       result = TokenPrice.fromJson(json);
//     }
//   }
//
//   WalletTokenPriceResponse.withError(WalletError err) {
//     error = err;
//   }
//
//   Map<String, dynamic> toJson() {
//     if(error != null){
//       return {
//         'code': error!.code,
//         'msg': error!.message,
//       };
//     }
//     return {
//       'symbol': result?.symbol,
//       'price': result?.price,
//     };
//   }
// }
//
//
// class WalletSendTokenResponse extends BaseWalletResponse {
//   bool success = false;
//   String? transactionHash;
//   WalletError? error;
//
//   WalletSendTokenResponse();
//
//   WalletSendTokenResponse.fromJson(Map<dynamic, dynamic> json) {
//     if(json['success'] != null && json['success'] == false){
//       success = false;
//       error = WalletError(message: json['errors'], code: 400);
//     } else if(json['error'] != null){
//       success = false;
//       error = WalletError.fromJson(json['error']);
//     } else {
//       success = true;
//       transactionHash = json['transaction_hash'];
//     }
//   }
//
//   WalletSendTokenResponse.withError(WalletError err) {
//     error = err;
//     success = false;
//   }
//
//   Map<String, dynamic> toJson() {
//     if(error != null){
//       return {
//         'success': false,
//         'errors': error,
//       };
//     }
//     return {
//       'transaction_hash': transactionHash,
//     };
//   }
// }
//
