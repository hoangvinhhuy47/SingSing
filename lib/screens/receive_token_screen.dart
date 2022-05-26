import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class ReceiveTokenScreen extends StatefulWidget {
  final Map<String, dynamic>? args;
  const ReceiveTokenScreen({Key? key, this.args}) : super(key: key);

  @override
  _ReceiveTokenScreenState createState() => _ReceiveTokenScreenState();
}

class _ReceiveTokenScreenState extends State<ReceiveTokenScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Balance? _balance;

  @override
  void initState() {
    _balance = widget.args?['balance'];
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
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1E2336),
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(l('Receive Token')),
    );
  }

  Widget _buildBody() {
    LoggerUtil.info('address ${widget.args}');
    final String address = widget.args?['address'];
    final String logoUrl = widget.args?['logo'];
    const logoSize = 42;
    ImageProvider tokenImage;
    if(logoUrl.startsWith('http')){
      tokenImage = CachedNetworkImageProvider(logoUrl,
        maxWidth: logoSize,
        maxHeight: logoSize,
      );
    } else {
      tokenImage = AssetImage(assetImg(logoUrl));
    }

    return Container(
      color: const Color(0xFF1E2336),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            color: Colors.white, // Color(0xFF171A29),
            child: QrImage(
              data: address,
              version: QrVersions.auto,
              size: 200,
              gapless: false,
              embeddedImage: tokenImage,
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(42, 42),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            address,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xFFB1BBD2),
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: '${l('Send only')} ',
                  style: s(context,
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              _buildTextTokenName(),
              TextSpan(
                  text: ' ${l('to this address. Sending any other coins may result in permanent loss')}.',
                  style: s(context,
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ]),
          ),
          const Spacer(),
          DefaultGradientButton(
            text: l('COPY ADDRESS'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: address));
              Fluttertoast.showToast(msg: l('Copied'));
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  _buildTextTokenName() {
    String secret = _balance?.secretType == secretTypeBsc ? '(BEP20)' : _balance?.secretType ?? '';
    String symbol = _balance?.symbol ?? "BNB";
    return TextSpan(
        text: '$symbol $secret',
        style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700));
  }

}
