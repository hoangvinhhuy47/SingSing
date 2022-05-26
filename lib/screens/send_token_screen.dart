import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/extensions/string_extension.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/numeric_keyboard.dart';


class SendTokenScreen extends StatefulWidget {
  final Map<String, dynamic>? args;
  const SendTokenScreen({Key? key, this.args}) : super(key: key);

  @override
  _SendTokenScreenState createState() => _SendTokenScreenState();
}

class _SendTokenScreenState extends State<SendTokenScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _addressController = TextEditingController(text: '');
  final  _amountFocusNode = FocusNode();
  final _amountNotifier = ValueNotifier<String>("");
  String _amountDollar = '';

  final textFieldBorderColorNormal = const Color(0xFF413D3D);
  final textFieldBorderColorActive = const Color(0xFF5894ED);
  Color _amountBorderColor = const Color(0xFF413D3D);


  @override
  void initState() {
    _addressController.addListener(_onAddressChanged);
    _amountNotifier.addListener(() {
      _onAmountChanged(_amountNotifier.value);
    });
    _amountFocusNode.addListener(() {
      setState(() {
        _amountBorderColor = _amountFocusNode.hasFocus ? textFieldBorderColorActive : textFieldBorderColorNormal;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
    _amountFocusNode.dispose();
    _amountNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ColorUtil.primary,
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('${l('Send')} ${widget.args!['name']}'),
    );
  }

  Widget _buildBody() {
    var totalAmountText = _getDollarPrice(NumberFormatUtil.tokenFormat(widget.args!['balance']));
    totalAmountText = totalAmountText.isNotEmpty ? ' (\$$totalAmountText)' : '';
    return MyKeyboardActions(
      config: _buildConfig(),
      isDialog: false,
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
      focusNode: _amountFocusNode,
      disableScroll: true,
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 24),
                  child: Text(
                    l('Recipient Address'),
                    style: MyStyles.of(context).tooltipText(),
                  ),
                ),
                _buildAddressTextField(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 24),
                    child: Row(
                      children: [
                        Text(
                          l('Amount') + ' ' + widget.args!['name'],
                          style: MyStyles.of(context).tooltipText(),
                        ),
                        Expanded(child: Text('${NumberFormatUtil.tokenFormat(widget.args!['balance'])} ${widget.args!['name']}$totalAmountText',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ))
                      ],
                    )
                ),
                _buildAmountTextField(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Text(_amountDollar,
                    style: MyStyles.of(context).tooltipText()
                        .copyWith(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          _buildNextButton(),
        ],
      ),
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
            ),
        ),
      );
  }

  _buildAmountTextField(){
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: _amountBorderColor, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          KeyboardCustomInput<String>(
            height: 45,
            focusNode: _amountFocusNode,
            notifier: _amountNotifier,
            builder: (context, val, hasFocus) {
              // _onAmountChanged(val);
              return Container(
                padding: const EdgeInsets.only(left: 18.0, right: 70),
                child: Text(val,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          Positioned(
            top: -1.5,
            right: 3,
            child: TextButton(
              onPressed: () {
                _amountNotifier.value = NumberFormatUtil.tokenFormat(widget.args!['balance']);
              },
              child: Text(l('Max'), style: const TextStyle(color: ColorUtil.mainPink),)
          ),)
        ],
      ),
    );

  }

  KeyboardActionsConfig _buildConfig(){
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: const Color(0xFF35363F),
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
            focusNode: _amountFocusNode,
            toolbarButtons: [
              //button 1
                  (node) {
                return TextButton(onPressed: () async {
                  final cdata = await Clipboard.getData(Clipboard.kTextPlain);
                  if(cdata != null && cdata.text != null){
                    _amountNotifier.value = cdata.text!;
                  }
                }, child: Text(l('Paste')));
              },
              //button 2
                  (node) {
                return TextButton(onPressed: () async {
                  _amountNotifier.value = '';
                }, child: Text(l('Clear')));
              },
                  (node) {
                return TextButton(onPressed: () async {
                  node.unfocus();
                }, child: Text(l('Done')));
              },
            ],
            footerBuilder: (_) => NumericKeyboard(
              focusNode: _amountFocusNode,
              notifier: _amountNotifier,
            ),
          )
        ]
    );
  }


  _buildNextButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: MyStyles.horizontalMargin, horizontal: 54),
      child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 24)),
              backgroundColor:
              MaterialStateProperty.all(const Color(0xFF33394F)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ))),
          onPressed: _onPressedNext,
          child: Text(
            l('Next'),
            style: const TextStyle(color: Colors.white),
          )),
    );
  }

  _onAmountChanged(String text){
    setState(() {
      final d = _getDollarPrice(text);
      _amountDollar = d.isNotEmpty ? '~ \$$d' : '';
    });
  }

  _onAddressChanged(){

  }

  _onScanButtonPressed() async {
    // check permission
    final status = await Permission.camera.status;
    LoggerUtil.info('camera status: $status');
    if (await Permission.camera.request().isGranted) {
      final result = await Navigator.pushNamed(context, Routes.sendTokenScanQrCodeScreen);
      if(result != null && result is String){
        _addressController.text = result;
      }
    } else {
      LoggerUtil.info('please grant camera');
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

  _onPressedNext(){
    final address = _addressController.text;
    final amount = _amountNotifier.value;
    if(address.isEmpty){
      showSnackBarError(context: context, message: l('Address cannot be empty'));
      return;
    }
    if(!StringExtension.validateWalletAddress(address)){
      showSnackBarError(context: context, message: l('Incorrect recipient address'));
      return;
    }

    final price = widget.args!['price'];
    // if(price == null){
    //   return;
    // }
    if(amount.isEmpty) {
      showSnackBarError(context: context, message: l('Amount cannot be empty'));
      return;
    }



    final balance = widget.args!['balance'];
    var dAmount = NumberFormatUtil.parse(amount);

    if(dAmount > balance) {
      showSnackBarError(context: context, message: l('Not enough balance to send'));
     return;
    }

    if(dAmount <= 0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l('Invalid amount number')),
      ));
      return;
    }

    Navigator.pushNamed(context, Routes.sendTokenConfirmScreen, arguments: {
      'symbol': widget.args!['name'],
      'address': address,
      'amount': dAmount,
      'price': widget.args!['price'],
      'wallet': widget.args!['wallet'],
      'is_local': widget.args!['is_local'] ?? false,
      'secret_type': widget.args!['secret_type'],
      'token_address': widget.args!['token_address'],
    });
  }

  String _getDollarPrice(String? balance){
    if(balance == null || balance.isEmpty){
      return '';
    }

    final price = widget.args!['price'];
    if(price == null){
      return '';
    }

    var value = NumberFormatUtil.parse(balance);
    if(value == 0){
      return '';
    }

    final totalPrice = price * value;
    return NumberFormatUtil.currencyFormat(totalPrice);
  }
}
