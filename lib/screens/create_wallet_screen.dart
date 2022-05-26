import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/support_chain.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:sing_app/utils/theme_util.dart';
import 'package:sing_app/utils/token_util.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class CreateNewWalletScreen extends StatefulWidget {
  final SupportChain chain;
  const CreateNewWalletScreen({Key? key, required this.chain}) : super(key: key);

  @override
  _CreateNewWalletScreen createState() => _CreateNewWalletScreen();
}

class _CreateNewWalletScreen extends State<CreateNewWalletScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var mnemonic = '';


  @override
  void initState() {
    setState(() {
      mnemonic = bip39.generateMnemonic();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset : false,
      appBar: _buildAppBar(),
      body: SafeArea(
        left: false,
        right: false,
        child: Column(
          children: [
            Padding(
            padding: const EdgeInsets.all(MyStyles.horizontalMargin),
              child: Text(
                  l('Your secret phrase'),
                  textAlign: TextAlign.center,
                  style: s(context,
                    fontSize: 26,
                    color: ColorUtil.white
                  ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(MyStyles.horizontalMargin),
              child: Text(
                l('Please re-enter your secret phrase and save theme somewhere safe.'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: ColorUtil.white1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(MyStyles.horizontalMargin),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: _buildMnemonicButtons(),
              ),
            ),
            _buildCopyButton(),
            const Spacer(),
            _buildNotice(),
            _buildNextButton(),
          ],
        ),
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
        onPressed: () =>
            Navigator.of(context).pop(),
      ),
    );
  }

  _buildCopyButton() {
    return TextButton(
        onPressed: _onCopyButtonPressed,
        child: Text(l('Copy'))
    );
  }
  _buildNextButton() {
    return Container(
      padding: const EdgeInsets.all(MyStyles.horizontalMargin),
      child: DefaultGradientButton(
        width: double.infinity,
        text: l('Continue').toUpperCase(),
        onPressed: _onPressedNextButton,
      ),
    );
  }

  _buildNotice(){
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(MyStyles.horizontalMargin),
      decoration: BoxDecoration(
        color: const Color(0xFF473335),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(l('Do not share your secret phrase!'),
            textAlign: TextAlign.center,
            style: s(context, fontSize: 18, fontWeight: MyFontWeight.bold, color: ColorUtil.formErrorText),
          ),
          const SizedBox(height: 10,),
          Text(l('If someone has secret phrase, they will have full control of your wallet.'),
            textAlign: TextAlign.center,
            style: s(context, fontSize: 14, color: ColorUtil.formErrorText),
          ),
        ],
      ),
    );
  }

  _buildMnemonicButtons(){
    final words = TokenUtil.mnemonicWords(mnemonic);
    return List<Widget>.generate(words.length, (int index) {
      final word = words[index];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          // height: 30,
          padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 12),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: ColorUtil.formItemFocusedBorder),
            borderRadius: BorderRadius.circular(30),
            color: ColorUtil.blockBg,
          ),
          child: Text.rich(TextSpan(
            children: [
              TextSpan(text: '${index + 1}  ',
                style: MyStyles.of(context).buttonTextStyle().copyWith(
                    fontSize: 14,
                    color: ColorUtil.formHintText
                ),
              ),
              TextSpan(text: word,
                style: MyStyles.of(context).buttonTextStyle().copyWith(
                    fontSize: 14,
                    color: Colors.white
                ),
              ),
            ],
          ),
          )
        )
      );
    });
  }

  _onPressedNextButton(){
    Navigator.pushNamed(context, Routes.createWalletVerifyMnemonicScreen,
        arguments: {
          'mnemonic': mnemonic,
          'chain': widget.chain
        }
    );
  }

  _onCopyButtonPressed() {
    Clipboard.setData(ClipboardData(text: mnemonic));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l('Copied')),
    ));
  }

}