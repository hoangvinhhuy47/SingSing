import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/screens/import_wallet_select_chain_screen.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class NewWalletScreen extends StatefulWidget {
  const NewWalletScreen({Key? key}) : super(key: key);

  @override
  _NewWalletScreenState createState() => _NewWalletScreenState();
}

class _NewWalletScreenState extends State<NewWalletScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: SafeArea(
        left: false,
        right: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5,),
             Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 SizedBox(
                   height: MediaQuery.of(context).size.height * 0.45,
                   child: ImageUtil.loadAssetsImage(
                       fileName: 'bg_new_wallet.png', fit: BoxFit.fitHeight),
                 ),
                 const SizedBox(height: 34),
                 Text(
                   l('Private and secure'),
                   style: const TextStyle(fontSize: 24, color: Colors.white),
                 ),
                 const SizedBox(height: 10),
                 Text(
                   l('Private keys never leave your device.'),
                   style: const TextStyle(
                     fontSize: 14,
                     color: Color(0xFF969696),
                   ),
                 ),
               ],
             ),
            const Spacer(),
            const SizedBox(height: 14),
            _buildCreateNewButton(),
            const SizedBox(height: MyStyles.horizontalMargin),
            _buildImportWalletButton(),
            const SizedBox(height: MyStyles.horizontalMargin)
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
      title: null,
    );
  }

  _buildCreateNewButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: DefaultGradientButton(
        text: l('Create a new wallet').toUpperCase(),
        onPressed: _onPressedCreateNewButton,
      ),
    );
  }

  _buildImportWalletButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: DefaultButton(
        text: l('I already have a wallet').toUpperCase(),
        onPressed: _onPressedImportWalletButton,
      ),
    );
  }

  _onPressedCreateNewButton(){
    Navigator.pushNamed(context, Routes.importWalletSelectChainScreen, arguments: {'type': SelectChainScreenType.create});
  }

  _onPressedImportWalletButton(){
    Navigator.pushNamed(context, Routes.importWalletSelectChainScreen, arguments: {'type': SelectChainScreenType.import});
  }

}