import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scan/scan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';

class SendTokenScanQrCodeScreen extends StatefulWidget {
  const SendTokenScanQrCodeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SendTokenScanQrCodeScreenState();
}

class _SendTokenScanQrCodeScreenState extends State<SendTokenScanQrCodeScreen> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _picker = ImagePicker();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildQrView(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ColorUtil.primary,
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        TextButton(onPressed: _onPhotoButtonPressed, child: const Text('Media'))
      ],
      title: Text(l('Scan QR Code')),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if(scanData.format == BarcodeFormat.qrcode) {
        controller.pauseCamera();
        Navigator.pop(context, scanData.code);
        return;
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    LoggerUtil.info('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(l('No camera permission'))),
      // );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onPhotoButtonPressed() async {
    if (await Permission.photos.request().isGranted) {
      try {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          final data = await Scan.parse(pickedFile.path);
          String address = data ?? '';
          if(address.contains(":")){
            address = address.split(':')[1];
          }
          Navigator.pop(context, address);
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } else {
      _showPhotoPermissionAlertDialog();
    }
  }

  _showPhotoPermissionAlertDialog() {
    // set up the buttons
    final cancelButton = TextButton(
      child: Text(l("Cancel")),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    final settingsButton = TextButton(
      child: Text(l("Settings")),
      onPressed:  () {
        Navigator.pop(context);
        openAppSettings();
      },
    );

    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(l('This feature requires photos access')),
      content: Text(l('To enable access, tap Settings and turn on Photo')),
      actions: [
        cancelButton,
        settingsButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}