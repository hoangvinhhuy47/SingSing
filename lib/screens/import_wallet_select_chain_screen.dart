import 'package:flutter/material.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/support_chain.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';

enum SelectChainScreenType {
  create,
  import,
}

class ImportWalletSelectChainScreen extends StatefulWidget {
  final SelectChainScreenType screenType;

  const ImportWalletSelectChainScreen({Key? key, required this.screenType})
      : super(key: key);

  @override
  _ImportWalletSelectChainScreen createState() =>
      _ImportWalletSelectChainScreen();
}

class _ImportWalletSelectChainScreen
    extends State<ImportWalletSelectChainScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<SupportChain> _chains = [];

  @override
  void initState() {
    setState(() {
      _chains.add(AppConfig.instance.values.supportChains[secretTypeBsc]!);
      _chains.add(AppConfig.instance.values.supportChains[secretTypeEth]!);
    });
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
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
                horizontal: MyStyles.horizontalMargin),
            itemCount: _chains.length,
            itemBuilder: (context, index) {
              return _buildListItem(index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                  height: 0, color: ColorUtil.primary, thickness: 2);
            },
          ),
        ));
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
      centerTitle: true,
      title: Text(l('Import')),
    );
  }

  _buildListItem(int index) {
    final item = _chains[index];
    final isFirstItem = index == 0;
    final isLastItem = index == _chains.length - 1;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isFirstItem ? 10.0 : 0.0),
        topRight: Radius.circular(isFirstItem ? 10.0 : 0.0),
        bottomLeft: Radius.circular(isLastItem ? 10.0 : 0.0),
        bottomRight: Radius.circular(isLastItem ? 10.0 : 0.0),
      ),
      child: Material(
        child: Ink(
          decoration: const BoxDecoration(color: ColorUtil.formItemBg),
          child: InkWell(
            splashColor: const Color(0xFF394A83),
            child: Container(
              padding: const EdgeInsets.all(MyStyles.horizontalMargin),
              child: Row(
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
                        child: _buildChainIcon(item)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: MyStyles.horizontalMargin,
                          right: MyStyles.horizontalMargin),
                      child: Text(
                        item.name,
                        style: const TextStyle(
                            color: Color(0xFFFFFFFF), fontSize: 18),
                      ),
                    ),
                  ),
                  ImageUtil.loadAssetsImage(
                      fileName: 'ic_arrow_right.svg',
                      color: const Color(0xFF8B8B8B)),
                ],
              ),
            ),
            onTap: () => _onTapItemIndex(index),
          ),
        ),
      ),
    );
  }

  Widget _buildChainIcon(SupportChain item) {
    return ImageUtil.loadAssetsImage(
        fileName: chainIcon(item.secretType), height: Constants.tokenIconSize);
  }

  _onTapItemIndex(int index) {
    final item = _chains[index];
    if (widget.screenType == SelectChainScreenType.import) {
      Navigator.pushNamed(context, Routes.importWalletScreen, arguments: item);
    } else {
      Navigator.pushNamed(context, Routes.createNewWalletBackupScreen,
          arguments: item);
    }
  }
}
