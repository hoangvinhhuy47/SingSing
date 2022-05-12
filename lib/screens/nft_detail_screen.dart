import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/nft_detail/nft_detail_screen_bloc.dart';
import 'package:sing_app/blocs/nft_detail/nft_detail_screen_event.dart';
import 'package:sing_app/blocs/nft_detail/nft_detail_screen_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/covalent_nft.dart';
import 'package:sing_app/data/models/moralis_nft.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/outline_widget.dart';

class NftDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  const NftDetailScreen({Key? key, this.args}) : super(key: key);

  @override
  _NftDetailScreenState createState() => _NftDetailScreenState();
}

class _NftDetailScreenState extends State<NftDetailScreen> {
  late NftDetailScreenBloc _nftDetailScreenBloc;
  late MoralisNft _nft;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _nftDetailScreenBloc = BlocProvider.of<NftDetailScreenBloc>(context);
    _nft = _nftDetailScreenBloc.nft;

    super.initState();
  }

  @override
  void dispose() {
    _nftDetailScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NftDetailScreenBloc, NftDetailScreenState>(
      listener: (ctx, state) {
        // LoggerUtil.info('wallet screen state: $state');
      },
      builder: (ctx, state) {
        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(),
          body: _buildBody(context),
          backgroundColor: const Color(0xFF161B2E),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        systemOverlayStyle: systemUiOverlayStyle,
        leading: IconButton(
          icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
          tooltip: l('Back'),
          onPressed: () => Navigator.of(context).pop(),
        ));
  }

  _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                width: size.width,
                height: size.width + 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.network(
                      _nft.externalData?.image ?? '',
                      fit: BoxFit.fill,
                    ).image,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: GestureDetector(
                  child: ImageUtil.loadNetWorkImage(
                      url: _nft.externalData?.image ?? '',
                      height: size.width - 80,
                      width: size.width - 80,
                      fit: BoxFit.cover),
                  onTap: _onTapBtnPlayNft,
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(bottom: 100),
              //   child: _buildBtnPlayVideo(context),
              // ),
            ],
          ),

          SizedBox(height: 30, width: size.width),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              _nft.externalData?.name ?? '',
              textAlign: TextAlign.left,
              style: s(context,
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 18),
          // GestureDetector(
          //   child: ImageUtil.loadAssetsImage(fileName: 'btn_send_nft.png'),
          //   onTap: _onTapSendNft,
          // ),
          DefaultGradientButton(
            text: l('Send').toUpperCase(),
            onPressed: _onTapSendNft,
            width: size.width - 40,
            titleStyle: s(context, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 30),
          OutlineWidget(
              strokeWidth: 2,
              radius: 24,
              gradient:
                  const LinearGradient(colors: ColorUtil.defaultGradientButton),
              child: _buildContractInfo(context)),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildBtnPlayVideo(BuildContext context) {

    return Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            child: ImageUtil.loadAssetsImage(fileName: 'btn_play_video.svg'),
            onTap: _onTapBtnPlayNft,
          ),
        ));
  }

  Widget _buildContractInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final tsLabel = s(context,
        color: ColorUtil.lightGrey, fontSize: 14, fontWeight: FontWeight.w400);
    final tsDetail = s(context,
        color: ColorUtil.white, fontSize: 14, fontWeight: FontWeight.w500);

    return Container(
      width: size.width - 40,
      height: 280,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: const Color(0xFF20273F),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: Text('${l('Creator')}:', style: tsLabel)),
              Expanded(
                  flex: 3,
                  child: Text(_getAddressText(_nft.ownerOf),
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: tsDetail)),
            ],
          ),
          ..._buildDivider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(l('${l('Category')}:'), style: tsLabel),
              ),
              Expanded(
                flex: 3,
                child: Text(
                    l('Song'),
                    textAlign: TextAlign.right,
                    style: tsDetail
                ),
              ),
            ],
          ),
          ..._buildDivider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('${l('Contract Address')}:', style: tsLabel),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(_getAddressText(_nft.tokenAddress),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            style: tsDetail)),
                    _buildCopyButton(),
                  ],
                ),
              ),
            ],
          ),
          ..._buildDivider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Token ID:', style: tsLabel),
              ),
              Expanded(
                flex: 3,
                child: Text(_nft.tokenId ?? '...',
                    textAlign: TextAlign.right, style: tsDetail),
              ),
            ],
          ),
          ..._buildDivider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Blockchain', style: tsLabel),
              ),
              Expanded(
                flex: 3,
                child: Text(App.instance.currentWallet?.secretType == secretTypeBsc ? 'Binance Smart Chain' : (_nft.name ?? '...'),
                    textAlign: TextAlign.right, style: tsDetail),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget _buildTextDuration() {
  //   String strDuration = '00:00:00';
  //   if (_nftDetailScreenBloc.duration != null) {
  //     strDuration =
  //         '${_nftDetailScreenBloc.duration!.inHours}:${_nftDetailScreenBloc.duration!.inMinutes}:${_nftDetailScreenBloc.duration!.inSeconds}';
  //   } else {
  //     strDuration = '';
  //   }
  //   return Text(strDuration,
  //       style: s(context,
  //           color: ColorUtil.lightGrey,
  //           fontSize: 13,
  //           fontWeight: FontWeight.w400));
  // }

  List<Widget> _buildDivider() {
    return [
      const SizedBox(height: 12),
      const Divider(
        height: 1,
        color: Color(0XFF353B4F),
      ),
      const SizedBox(height: 12)
    ];
  }

  String _getAddressText(String? address) {
    if (address != null && address.length > 20) {
      return '${address.substring(0, 10)}...${address.substring(address.length - 10)}';
    }
    return '...';
  }

  _onTapBtnCopy() async {
    String address = _nft.tokenAddress ?? '';
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData?.text == address) {
      return;
    }
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l('Copied') + ': $address'),
    ));
  }

  _onTapSendNft() {
    Navigator.pushNamed(context, Routes.sendNftScreen, arguments: {
      'nft': _nft,
      'wallet': App.instance.currentWallet,
    });
  }

  _onTapBtnPlayNft() {
    Navigator.pushNamed(context, Routes.videoPlayerScreen, arguments: {
      'nft': _nft,
    });
  }

  _buildCopyButton() {
    return Container(
        width: 32,
        height: 32,
        transform: Matrix4.translationValues(6.0, 0.0, 0.0),
        child: TextButton(
          onPressed: _onTapBtnCopy,
          style: ButtonStyle(
            overlayColor:
                MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.3)),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            shape:
                MaterialStateProperty.all<CircleBorder>(const CircleBorder()),
            backgroundColor:
                MaterialStateProperty.all<Color>(ColorUtil.primary),
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: ImageUtil.loadAssetsImage(
                fileName: 'ic_copy.svg', width: 24, fit: BoxFit.scaleDown),
          ),
        ));
  }
}
