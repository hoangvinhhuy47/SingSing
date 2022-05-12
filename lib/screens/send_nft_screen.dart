import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sing_app/blocs/send_nft/send_nft_screen_bloc.dart';
import 'package:sing_app/blocs/send_nft/send_nft_screen_event.dart';
import 'package:sing_app/blocs/send_nft/send_nft_screen_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/dialog/loading_dialog.dart';

class SendNftScreen extends StatefulWidget {
  final Map<String, dynamic>? args;
  const SendNftScreen({Key? key, this.args}) : super(key: key);

  @override
  _SendNftScreenState createState() => _SendNftScreenState();
}

class _SendNftScreenState extends State<SendNftScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _addressController = TextEditingController(text: '');
  late SendNftScreenBloc _sendNftScreenBloc;

  @override
  void initState() {
    _sendNftScreenBloc = BlocProvider.of<SendNftScreenBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _sendNftScreenBloc.close();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendNftScreenBloc, SendNftScreenState>(
        listener: (ctx, state) {
          if(state is SendNftScreenStateSending){
            LoadingDialog.show(context, l('Sending...'));
          }
          if(state is SendNftScreenStateSent) {
            var count = 0;
            Navigator.popUntil(context, (route) {
              if(count++ == 3){
                return true;
              }
              return false;
            });
          }
          if(state is SendNftScreenStateErrorSending){
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        builder: (ctx, state) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: _buildAppBar(),
            body: SafeArea(
              left: false,
              right: false,
              child: _buildBody(),
            ),
          );
        }
    );
  }

  Widget _buildBody() {
    double imageWidth = MediaQuery.of(context).size.width - MyStyles.horizontalMargin * 2;
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: MyStyles.horizontalMargin,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: ImageUtil.loadNetWorkImage(
                    url: _sendNftScreenBloc.nft.externalData?.image ?? '',
                    height: imageWidth,
                    width: imageWidth,
                    fit: BoxFit.cover
                ),
              ),
              const SizedBox(height: 24,),
              Text(_sendNftScreenBloc.nft.externalData?.name ?? '',
                style: const TextStyle(
                  color: ColorUtil.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 24),
                child: Text(
                  l('Receiver Address'),
                  style: MyStyles.of(context).tooltipText(),
                ),
              ),
              _buildAddressTextField(),
            ],
          ),
        ),
        const SizedBox(height: 24,),
        _buildSendButton(),
        const SizedBox(height: 24,),
      ],
    ),
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
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(l('Send NFT')),
    );
  }

  _buildSendButton() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: MyStyles.horizontalMargin, horizontal: 54),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: ColorUtil.defaultGradientButton
            ),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24)),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ))),
              onPressed: _onPressedSend,
              child: Text(
                l('Send'),
                style: const TextStyle(color: Colors.white),
              )),
      )
    );
  }

  _buildAddressTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      autocorrect: false,
      enableSuggestions: false,
      controller: _addressController,
      decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.only(top: 14.0, bottom: 14.0, left: 18.0),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Color(0xFF413D3D)),
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF413D3D))),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(onPressed: () async{
                final cdata = await Clipboard.getData(Clipboard.kTextPlain);
                if(cdata != null && cdata.text != null){
                  _addressController.text = cdata.text!;
                }
              }, child: Text(l('Paste'), style: const TextStyle(color: ColorUtil.mainPink),)),
              IconButton(
                  onPressed: _onScanButtonPressed,
                  icon: ImageUtil.loadAssetsImage(fileName: 'ic_scan.svg')
              ),
            ],
          ),),
    );
  }

  _onScanButtonPressed() async {
    // check permission
    if (await Permission.camera.request().isGranted) {
      final result = await Navigator.pushNamed(context, Routes.sendTokenScanQrCodeScreen);
      if(result != null && result is String){
        _addressController.text = result;
      }
    } else {
      _showCameraPermissionAlertDialog();
    }
  }

  _showCameraPermissionAlertDialog() {
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
      title: Text(l('This feature requires camera access')),
      content: Text(l('To enable access, tap Settings and turn on Camera')),
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

  _onPressedSend(){
    final address = _addressController.text;
    if(address.isEmpty){
      return;
    }
    _sendNftScreenBloc.address = address;
    _sendNftScreenBloc.add(SendNftScreenEventSending());
  }
}