import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/setting_wallet/setting_wallet_bloc.dart';
import 'package:sing_app/blocs/setting_wallet/setting_wallet_event.dart';
import 'package:sing_app/blocs/setting_wallet/setting_wallet_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/dialog/custom_alert_dialog.dart';
import 'package:sing_app/widgets/ss_check_box.dart';

import '../../application.dart';
import '../../data/event_bus/event_bus_event.dart';
import '../../routes.dart';

class SettingWalletScreen extends StatefulWidget {
  final tag = 'SettingWalletScreen';

  const SettingWalletScreen({Key? key}) : super(key: key);

  @override
  _SettingWalletScreenState createState() => _SettingWalletScreenState();
}

class _SettingWalletScreenState extends State<SettingWalletScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SettingWalletBloc _settingWalletBloc;

  @override
  void initState() {
    _settingWalletBloc = BlocProvider.of<SettingWalletBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _settingWalletBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: WillPopScope(
        onWillPop: () async {
          _eventBack();
          return false;
        },
        child: SafeArea(
          left: false,
          right: false,
          child: _buildBloc(),
        ),
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
        onPressed: _eventBack,
      ),
      actions: [
        if (_settingWalletBloc.wallet.isLocal)
          IconButton(
            icon: ImageUtil.loadAssetsImage(
                fileName: 'ic_delete.svg',
                width: 24,
                height: 24,
                color: ColorUtil.white),
            tooltip: l('Delete'),
            onPressed: () => {
              _showAlertDeleteWallet(),
            },
          ),
      ],
      title: Text(l('Setting wallet')),
    );
  }

  void _eventBack () => Navigator.of(context).pop(_settingWalletBloc.reloaded);

  Widget _buildBloc() {
    return BlocConsumer<SettingWalletBloc, SettingWalletState>(
      listener: (ctx, state) {
        if (state is SettingWalletStateDeleteWalletDone) {
          if (state.isSuccess) {
            App.instance.eventBus.fire(EventBusNewWalletCreatingSuccessful());
            Navigator.popUntil(context, (route) {
              return route.navigator?.canPop() != true;
            });
            showSnackBarSuccess(context: context, message: l(state.message));

          } else {
            showSnackBarError(context: context, message: l(state.message));
          }
        }
      },
      // buildWhen: (preState, nextState) {
      //   return nextState is! UserInfoRefreshState;
      // },
      builder: (ctx, state) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.fromLTRB(20, 0, MyStyles.horizontalMargin, 0),
      color: ColorUtil.mainBg,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  l('General settings').toUpperCase(),
                  style: MyStyles.of(context).settingWalletTextStyle().copyWith(
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: 8),
                _buildSettingWalletButton(
                    text: 'Edit wallet name',
                    onPressed: _onPressEditWalletName),
                const SizedBox(height: 8),
                if (_settingWalletBloc.wallet.isLocal)
                  _buildSettingWalletButton(
                      text: 'Show wallet passphrase',
                      onPressed: _onPressShowPassPhrase),
                const SizedBox(height: 8),
                if (_settingWalletBloc.wallet.isLocal)
                  _buildSettingWalletButton(
                      text: 'Show wallet private key',
                      onPressed: _onPressShowPrivateKey),
                const SizedBox(height: 24),
                Text(l('Token settings').toUpperCase(),
                    style: MyStyles.of(context)
                        .settingWalletTextStyle()
                        .copyWith()),
                const SizedBox(height: 15),
                TextField(
                  // controller: _txtContractAddressControler,
                  maxLines: 1,
                  decoration: InputDecoration(
                      fillColor: const Color(0xFF242B43),
                      filled: true,
                      hintText: l('Search'),
                      contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide:
                            BorderSide(width: 1, color: Colors.transparent),
                      ),
                      border: const OutlineInputBorder(
                          // borderSide: BorderSide(color: Color(0xFF413D3D))
                          ),
                      suffixIcon: IconButton(
                          onPressed: () {},
                          icon: ImageUtil.loadAssetsImage(
                              fileName: 'ic_search_setting_wallet.svg'))),
                  style: s(context, color: Colors.white, fontSize: 16),
                  onChanged: (text) {
                    _settingWalletBloc
                        .add(OnTextSearchChangedEvent(text: text.trim()));
                  },
                ),
                const SizedBox(height: 16),
                _buildListTokens(),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 48,
                width: 250,
                decoration: BoxDecoration(
                  // color: colors != null && colors!.isNotEmpty ? colors!.first : null,
                  color: const Color(0xFF33394F),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: _onPressAddCustomToken,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageUtil.loadAssetsImage(
                          fileName: 'ic_add_custom_token.svg'),
                      const SizedBox(width: 10),
                      Text(l('Add custom token').toUpperCase(),
                          style: s(
                            context,
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListTokens() {
    return ListView.separated(
      // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0), //all(MyStyles.horizontalMargin),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _settingWalletBloc.balances.length,
      itemBuilder: (context, index) {
        return _buildListViewItem(index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: MyStyles.horizontalMargin,
        );
      },
    );
  }

  Widget _buildListViewItem(int index) {
    final item = _settingWalletBloc.balances[index];

    return Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        // width: Constants.tokenIconSize,
        // height: Constants.tokenIconSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.tokenIconSize / 2),
          color: ColorUtil.blockBg,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Constants.tokenIconSize,
              height: Constants.tokenIconSize,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Constants.tokenIconSize / 2),
              ),
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Constants.tokenIconSize / 2),
                  child: _buildTokenIcon(item)),
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(Constants.tokenIconSize/2),
            //   child: ImageUtil.loadNetWorkImage(url: '', height: Constants.tokenIconSize),
            // ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.symbol,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MyStyles.of(context)
                          .settingWalletTextStyle()
                          .copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          )),
                  const SizedBox(height: 5),
                  Text(NumberFormatUtil.tokenFormat(item.balance),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MyStyles.of(context)
                          .settingWalletTextStyle()
                          .copyWith(
                            color: Colors.white,
                            fontSize: 13,
                          )),
                ],
              ),
            ),
            SSCheckbox(
                width: 55,
                height: 29,
                isChecked: !item.isHidden,
                onCheckedChange: (bool isChecked) {
                  _settingWalletBloc.add(OnBalanceCheckedChangeEvent(
                      isChecked: isChecked, balance: item));
                }),
          ],
        ));
  }

  Widget _buildTokenIcon(Balance item) {
    if (item.tokenAddress?.isNotEmpty ?? false) {
      if (AppConfig.instance.isSingSingContract(item.tokenAddress!)) {
        return ImageUtil.loadAssetsImage(
            fileName: 'ic_singsing_token.png', height: Constants.tokenIconSize);
      }

      return ImageUtil.loadNetWorkImage(
          url:
              '$tokenIconHost${item.secretType.toLowerCase()}/${item.tokenAddress!}.png',
          height: Constants.tokenIconSize);
    } else {
      return ImageUtil.loadAssetsImage(
          fileName: tokenIcon(item.secretType),
          height: Constants.tokenIconSize);
    }
  }

  _buildSettingWalletButton(
      {required String text, void Function()? onPressed}) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(ColorUtil.blockBg),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ))),
        child: Container(
          padding:
              const EdgeInsets.only(left: MyStyles.horizontalMargin, right: 8),
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Text(l(text),
                    style:
                        MyStyles.of(context).settingWalletTextStyle().copyWith(
                              fontSize: 16,
                            )),
              ),
              ImageUtil.loadAssetsImage(fileName: 'ic_arrow_right.svg')
            ],
          ),
        ));
  }

  _onPressAddCustomToken() async {
    final result =
        await Navigator.pushNamed(context, Routes.addCustomTokenScreen);
    LoggerUtil.info('Navigator.pushNamed addCustomTokenScreen result: $result',
        tag: '$widget');
    if (result == true) {
      _settingWalletBloc.add(SettingWalletEventStart());
    }
  }

  void _showAlertDeleteWallet() {
    CustomAlertDialog.show(
      context,
      content: l('Do you want delete this wallet?'),
      leftText: l('Delete'),
      rightText: l('Cancel'),
      isLeftPositive: true,
      isShowTitle: false,
      leftAction: () {
        _deleteWallet();
        Navigator.pop(context, true);
      },
      rightAction: () {
        Navigator.pop(context);
      },
    );
  }

  _deleteWallet() {
    _settingWalletBloc.add(OnWalletDeletingEvent());
  }

  Future _onPressEditWalletName() async {
    final result = await Navigator.pushNamed(
        context, Routes.changeWalletNameScreen,
        arguments: {
          'current_name': _settingWalletBloc.wallet.description,
          'wallet': _settingWalletBloc.wallet
        });
    if (result == true) {
      _settingWalletBloc.add(SettingWalletEventReload());
    }
  }

  _onPressShowPrivateKey() {
    _eventShowPrivateThing(_settingWalletBloc.wallet.privateKey);
    // AppLockUtil.checkPassCode(
    //   context: context,
    //   function: () {
    //     _eventShowPrivateThing(_settingWalletBloc.wallet.privateKey);
    //   },
    // );
  }
  _onPressShowPassPhrase()  {
    _eventShowPrivateThing(_settingWalletBloc.wallet.mnemonic);
    // AppLockUtil.checkPassCode(
    //   context: context,
    //   function: () {
    //     _eventShowPrivateThing(_settingWalletBloc.wallet.mnemonic);
    //   },
    // );
  }

  _eventShowPrivateThing(String? data)  {
    Navigator.pushNamed(context, Routes.showWalletPassphraseScreen,
        arguments: {'wallet': _settingWalletBloc.wallet, 'data': data});
  }
}
