// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sing_app/utils/image_util.dart';
//
// import 'oauth2_webview.dart';
//
// class Oauth2Dialog {
//   BuildContext context;
//   Function? onLoginResult;
//   bool? isRegistrations;
//
//   Oauth2Dialog({
//     required this.context,
//     this.onLoginResult,
//     this.isRegistrations
//   });
//
//   show() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       useSafeArea: true,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async {
//             if (onLoginResult != null) {
//               onLoginResult!(null, '');
//             }
//             return Future.value(false);
//           },
//           child: Dialog(
//             insetPadding: EdgeInsets.zero,
//             child: Stack(
//               children: [
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                   child: Oauth2Webview(
//                     onLoginResult: onLoginResult,
//                     isRegistrations: isRegistrations,
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(40 / 2),
//                         // border: Border.all(width: 2, color: Colors.red),
//                         color: Colors.red),
//                     child: TextButton(
//                       child: ImageUtil.loadAssetsImage(
//                           fileName: 'btn_close.svg'),
//                       onPressed: () {
//                         if (onLoginResult != null) {
//                           onLoginResult!(null, '');
//                         }
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ) ;
//       },
//     );
//   }
// }
