import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/theme_util.dart';
import 'package:sing_app/utils/token_util.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class ShowWalletPassphrasePrivateKeyScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  const ShowWalletPassphrasePrivateKeyScreen({Key? key, this.args})
      : super(key: key);

  @override
  _ShowPassphraseState createState() => _ShowPassphraseState();
}

class _ShowPassphraseState extends State<ShowWalletPassphrasePrivateKeyScreen> {
  var data = '';
  var isAgree = false;
  var isShowMnemonic = true;
  final List<bool> _checkList = [false, false, false];

  @override
  void initState() {
    setState(() {
      data = widget.args?['data'];
      isAgree = false;
    });
    isShowMnemonic = data == widget.args?['wallet'].mnemonic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
            left: false,
            right: false,
            child: isAgree ? _buildBodyAgree() : _buildBodyNotAgreeYet()));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ColorUtil.primary,
      // systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () => {Navigator.of(context).pop()},
      ),
    );
  }

  Widget _buildBodyNotAgreeYet() {
    return Container(
        padding: const EdgeInsets.all(MyStyles.horizontalMargin),
        child: Column(
          children: [
            Expanded(
                child: ImageUtil.loadAssetsImage(
                    fileName: 'bg_new_wallet.png', fit: BoxFit.scaleDown)),
            const SizedBox(
              height: 30,
            ),
            _buildCheckButton(
                l(isShowMnemonic
                    ? 'If i lose my secret phrase, my funds will be lost forever.'
                    : 'If i lose my private key, my funds will be lost forever.'),
                0),
            const SizedBox(
              height: 10,
            ),
            _buildCheckButton(
                l(isShowMnemonic
                    ? 'If i expose or share my secret phrase to anybody, my funds can get stolen.'
                    : 'If i expose or share my private key to anybody, my funds can get stolen.'),
                1),

            const SizedBox(
              height: 10,
            ),
            _buildCheckButton(
                l(isShowMnemonic
                    ? 'It is my full responsibility to keep my secret phrase secure.'
                    : 'It is my full responsibility to keep my private key secure.'),
                2),
            const SizedBox(
              height: MyStyles.horizontalMargin,
            ),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: MyStyles.horizontalMargin),
              child: DefaultButton(
                width: double.infinity,
                colors: _checkList[0] && _checkList[1] && _checkList[2]
                    ? ColorUtil.defaultGradientButton
                    : ColorUtil.defaultButton,
                onPressed: _checkList[0] && _checkList[1] && _checkList[2]
                    ? _onPressedNextButton
                    : null,
                text: l('Continue').toUpperCase(),
              ),
            ),
          ],
        ));
  }

  Widget _buildBodyAgree() {
    return Container(
      padding: const EdgeInsets.all(MyStyles.horizontalMargin),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            l(isShowMnemonic ? 'Your secret phrase' : 'Your private key'),
            textAlign: TextAlign.center,
            style: MyStyles.of(context).screenTitleText().copyWith(),
          ),
          const SizedBox(height: 14),
          Text(
            l('Write down or copy these characters in the right order and save theme somewhere safe.'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: ColorUtil.white,
                ),
          ),
          const SizedBox(height: 14),
          isShowMnemonic
              ? Padding(
                  padding: const EdgeInsets.all(MyStyles.horizontalMargin),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: _buildMnemonicButtons(),
                  ),
                )
              : _buildPrivateKey(),
          TextButton(onPressed: _onCopyButtonPressed, child: Text(l('Copy'))),
          const Spacer(),
          _buildNotice()
        ],
      ),
    );
  }

  _buildMnemonicButtons() {
    final words = TokenUtil.mnemonicWords(data);
    return List<Widget>.generate(words.length, (int index) {
      final word = words[index];
      return Container(
          height: 30,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
          margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
          decoration: BoxDecoration(
            border: Border.all(color: ColorUtil.formItemFocusedBorder),
            borderRadius: BorderRadius.circular(30),
            color: ColorUtil.blockBg,
          ),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${index + 1}  ',
                  style: MyStyles.of(context)
                      .buttonTextStyle()
                      .copyWith(fontSize: 14, color: ColorUtil.formHintText),
                ),
                TextSpan(
                  text: word,
                  style: MyStyles.of(context)
                      .buttonTextStyle()
                      .copyWith(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ));
    });
  }

  _buildPrivateKey() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtil.formItemFocusedBorder),
        borderRadius: BorderRadius.circular(30),
        color: ColorUtil.blockBg,
      ),
      child: Text(
        data,
        style: MyStyles.of(context)
            .buttonTextStyle()
            .copyWith(fontSize: 14, color: Colors.white),
      ),
    );
  }

  _buildNotice() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(MyStyles.horizontalMargin),
      decoration: BoxDecoration(
        color: const Color(0xFF473335),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            l(isShowMnemonic
                ? 'Do not share your secret phrase!'
                : 'Do not share your private key!'),
            textAlign: TextAlign.center,
            style: s(context,
                fontSize: 18,
                fontWeight: MyFontWeight.bold,
                color: ColorUtil.formErrorText),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            l(isShowMnemonic
                ? 'If someone has secret phrase, they will have full control of your wallet.'
                : 'If someone has private key, they will have full control of your wallet.'),
            textAlign: TextAlign.center,
            style: s(context, fontSize: 14, color: ColorUtil.formErrorText),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckButton(String text, int index) {
    return TextButton(
        onPressed: () {
          setState(() {
            _checkList[index] = !_checkList[index];
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorUtil.formItemBg),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(Size.zero),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: ColorUtil.formItemFocusedBorder),
          ),
          child: Row(
            children: [
              ImageUtil.loadAssetsImage(
                  fileName: _checkList[index]
                      ? 'ic_radio_checked.svg'
                      : 'ic_radio_uncheck.svg'),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  text,
                  style: MyStyles.of(context).hintText().copyWith(
                      fontSize: 14,
                      color: _checkList[index]
                          ? Colors.white
                          : ColorUtil.formHintText),
                ),
              ),
            ],
          ),
        ));
  }

  _onCopyButtonPressed() {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l('Copied')),
    ));
  }

  _onPressedNextButton() {
    setState(() {
      isAgree = true;
    });
  }
}
