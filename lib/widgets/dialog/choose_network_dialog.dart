// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sing_app/constants/enum.dart';
// import 'package:sing_app/utils/color_util.dart';
// import 'package:sing_app/utils/image_util.dart';
// import 'package:sing_app/utils/styles.dart';
//
// class ChooseNetworkDialog {
//   static void show(BuildContext context, {required Function onPressed}) {
//     showDialog(
//       barrierDismissible: false,
//       barrierColor: Colors.black12.withOpacity(0.6),
//       context: context,
//       builder: (ctx) {
//         return _ConfirmLeaveGroupDialogWidget(onPressed: onPressed);
//       },
//     );
//   }
// }
//
// class _ConfirmLeaveGroupDialogWidget extends StatelessWidget {
//   final Function onPressed;
//
//   const _ConfirmLeaveGroupDialogWidget({required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: 300,
//         height: 220,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//         child: Column(
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Spacer(),
//                 _btnClose(context),
//               ],
//             ),
//             _buildContent(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(BuildContext context) {
//     return Column(
//       // crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // const SizedBox(height: 10),
//         Text(
//           'Choose Network',
//           // textAlign: TextAlign.center,
//           style: s(context,
//               color: const Color(0xFF3052B7),
//               fontSize: 20,
//               fontWeight: FontWeight.w700),
//         ),
//         // const Divider(),
//         const SizedBox(height: 20),
//         TextButton(
//           child: Row(
//             children: [
//               Text(
//                 'Ethereum',
//                 textAlign: TextAlign.left,
//                 style: s(context,
//                     color: ColorUtil.mainGrey,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500),
//               ),
//               Spacer(),
//               ImageUtil.loadAssetsImage(fileName: 'ic_arrow_right.svg'),
//             ],
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             onPressed(NetworkType.eth);
//           },
//         ),
//         // const SizedBox(height: 5),
//         const Divider(),
//         TextButton(
//           child: Row(
//             children: [
//               Text(
//                 'BSC (Binance Smart Chain)',
//                 textAlign: TextAlign.left,
//                 style: s(context,
//                     color: ColorUtil.mainGrey,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500),
//               ),
//               Spacer(),
//               ImageUtil.loadAssetsImage(fileName: 'ic_arrow_right.svg'),
//             ],
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//             onPressed(NetworkType.bsc);
//           },
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }
//
//   Widget _btnClose(BuildContext context) {
//     return Material(
//       color: Colors.transparent, // Use here Material widget
//       child: Ink(
//         width: 35,
//         height: 35,
//         child: InkWell(
//           // customBorder: RoundedRectangleBorder(
//           //   borderRadius: BorderRadius.circular(30),
//           // ),
//           onTap: () {
//             Navigator?.pop(context);
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(5),
//             child: ImageUtil.loadAssetsImage(
//               fileName: assetImg('ic_close_dialog_grey.svg'),
//               height: 30,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
