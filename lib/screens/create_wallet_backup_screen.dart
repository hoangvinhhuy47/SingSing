import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/support_chain.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class CreateNewWalletBackupScreen extends StatefulWidget {
  final SupportChain chain;
  const CreateNewWalletBackupScreen({Key? key, required this.chain}) : super(key: key);

  @override
  _CreateNewWalletBackupScreen createState() => _CreateNewWalletBackupScreen();
}

class _CreateNewWalletBackupScreen extends State<CreateNewWalletBackupScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<bool> _checkList = [false, false, false];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: SafeArea(
        left: false,
        right: false,
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
              child: Column(
                children: [
                  Text(
                    l('Back up your wallet now!'),
                    style: MyStyles.of(context).screenTitleText(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: MyStyles.horizontalMargin,),
                  Text(
                    l('In the next step you will see Secret Phrase (12 words) that allows you to recover a wallet.'),
                    textAlign: TextAlign.center,
                    style: MyStyles.of(context).hintText(),
                  ),
                  const SizedBox(height: 30,),
                  Stack(
                    children: [
                      ImageUtil.loadAssetsImage(fileName: 'bg_backup_wallet.png'),
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: ImageUtil.loadAssetsImage(fileName: 'ic_backup_wallet_refresh.svg')
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  _buildCheckButton(l('If i lose my secret phrase, my funds will be lost forever.'), 0),
                  const SizedBox(height: 10,),
                  _buildCheckButton(l('If i expose or share my secret phrase to anybody, my funds can get stolen.'), 1),
                  const SizedBox(height: 10,),
                  _buildCheckButton(l('It is my full responsibility to keep my secret phrase secure.'), 2),
                ],
              )
            )),
            const SizedBox(height: MyStyles.horizontalMargin,),
            Padding(padding: const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
              child: DefaultButton(
                width: double.infinity,
                colors: _checkList[0] && _checkList[1] && _checkList[2]
                    ? ColorUtil.defaultGradientButton
                    : ColorUtil.defaultButton,
                onPressed: _checkList[0] && _checkList[1] && _checkList[2] ? _onPressedNextButton : null,
                text: l('Continue').toUpperCase(),
              ),
            ),
            const SizedBox(height: MyStyles.horizontalMargin,),
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

  _onPressedNextButton(){
    Navigator.pushNamed(context, Routes.createNewWallet, arguments: widget.chain);
  }

  Widget _buildCheckButton(String text, int index) {
    return TextButton(
        onPressed: (){
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
              ImageUtil.loadAssetsImage(fileName: _checkList[index] ? 'ic_radio_checked.svg' : 'ic_radio_uncheck.svg'),
              const SizedBox(width: 15,),
              Expanded(
                child: Text(text, style: MyStyles.of(context).hintText().copyWith(fontSize: 14, color: _checkList[index] ? Colors.white : ColorUtil.formHintText),),
              ),
            ],
          ),
        )
    );
  }

}