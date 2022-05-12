import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sing_app/blocs/add_custom_token/add_custom_token_bloc.dart';
import 'package:sing_app/blocs/add_custom_token/add_custom_token_event.dart';
import 'package:sing_app/blocs/add_custom_token/add_custom_token_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/contract_info.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/dialog/loading_dialog.dart';

import '../application.dart';
import '../routes.dart';

class AddCustomTokenScreen extends StatefulWidget {
  // final Map<String, dynamic>? args;
  const AddCustomTokenScreen({Key? key}) : super(key: key);

  @override
  _AddCustomTokenScreenState createState() => _AddCustomTokenScreenState();
}

class _AddCustomTokenScreenState extends State<AddCustomTokenScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AddCustomTokenBloc _addCustomTokenBloc;

  late TextStyle _txtTitleStyle;
  late BoxDecoration _boxDecoration;
  // late BoxDecoration _boxDecorationDisable;

  final _txtContractAddressControler = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _addCustomTokenBloc = BlocProvider.of<AddCustomTokenBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _addCustomTokenBloc.close();
    _txtContractAddressControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: SafeArea(
        left: false,
        right: false,
        child: _buildBloc(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: systemUiOverlayStyle,
      backgroundColor: const Color(0xFF1E2336),
      elevation: 0.0,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: _onTapBtnBack,
      ),
      centerTitle: true,
      title: Text(l('Add Custom Token')),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<AddCustomTokenBloc, AddCustomTokenState>(
      listener: (ctx, state) {
        // LoggerUtil.info('state: $state');
        if(state is AddCustomTokenLoadingState) {
          LoadingDialog.show(context, '....');
        }
        if (state is AddCustomTokenSuccessState) {
          Navigator.pop(context);
          showSnackBarSuccess(
              context: context, message: l('Add custom token success'));
        }
        if (state is AddCustomTokenErrorState) {
          Navigator.pop(context);
          showSnackBarError(context: context, message: state.error);
        }
      },
      // buildWhen: (preState, nextState) {
      //   return nextState is! UserInfoRefreshState;
      // },
      builder: (ctx, state) {
        bool isLoading = state is AddCustomTokenLoadingState;
        return _buildBody();
        // LoadingIndicator(
        //   isLoading: isLoading,
        //   child: _buildBody(),
        // );
      },
    );
  }

  Widget _buildBody() {
    return Container(
      color: const Color(0xFF1E2336),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: _buildForm(),
              ),
            ),
          ),
          DefaultButton(
            text: l('Add').toUpperCase(),
            onPressed: _onPressAddCustomToken,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildForm() {
    _txtTitleStyle = s(context,
        color: ColorUtil.lightGrey, fontSize: 14, fontWeight: FontWeight.w500);

    _boxDecoration = BoxDecoration(
      border: Border.all(
        color: const Color(0xFF413D3D),
      ),
      // color: ColorUtil.blockBg,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    );
    // _boxDecorationDisable = BoxDecoration(
    //   border: Border.all(
    //     color: ColorUtil.mainGrey,
    //   ),
    //   // color: ColorUtil.blockBg,
    //   borderRadius: const BorderRadius.all(Radius.circular(8)),
    // );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(l('Network'), style: _txtTitleStyle),
        const SizedBox(height: 8),
        GestureDetector(
          // onTap: _onTapChooseNetwork,
          child: Container(
            decoration: _boxDecoration,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Text(App.instance.currentWallet?.secretType ?? '',
                    style: s(context, fontSize: 16)),
                // const Spacer(),
                // SvgPicture.asset(
                //   assetImg('ic_arrow_right.svg'),
                //   color: Colors.white,
                //   fit: BoxFit.cover,
                //   alignment: Alignment.center,
                // ),
                // ImageUtil.loadAssetsImage(fileName: 'ic_arrow_right.svg'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(l('Contract Address'), style: _txtTitleStyle),
            const Spacer(),
            GestureDetector(
              onTap: _onTapQrcode,
              child: Row(
                children: [
                  Text(
                    l('Scan QR'),
                    style: s(context, color: ColorUtil.mainPink),
                  ),
                  const SizedBox(width: 8),
                  ImageUtil.loadAssetsImage(fileName: 'ic_scan_qrcode.svg'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _txtContractAddressControler,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 14.0, bottom: 14.0, left: 18.0),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Color(0xFF413D3D)),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF413D3D))),
              suffixIcon: IconButton(
                  onPressed: _onCopyButtonPressed,
                  icon: ImageUtil.loadAssetsImage(fileName: 'ic_copy.svg'))),
          onChanged: (text) {
            _addCustomTokenBloc
                .add(OnContractAddressEvent(contractAddress: text));
          },
        ),
        const SizedBox(height: 16),
        if (_addCustomTokenBloc.contractInfo != null)
          _buildContractInfo(context, _addCustomTokenBloc.contractInfo!)
        else
          Container(),
        const SizedBox(height: 20),
        Text(l('What is the Custom token?'),
            style: s(context, fontSize: 14, color: ColorUtil.mainPink)),
        const SizedBox(height: 20),
      ],
    );
  }

  _onCopyButtonPressed() {
    Clipboard.setData(ClipboardData(text: _txtContractAddressControler.text));
    showSnackBar(context,
        message: l('Copied') + ': ${_txtContractAddressControler.text}');
  }

  Widget _buildContractInfo(BuildContext context, ContractInfo contractInfo) {
    return Center(
      child: Container(
        // padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
        // width: 200,
        child: Column(
          children: [
            Text(l('Contract Info'), style: _txtTitleStyle),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(l('Name') + ':', style: _txtTitleStyle),
                ),
                Expanded(
                  flex: 4,
                  child: AutoSizeText(contractInfo.name,
                      maxLines: 2,
                      style: s(
                        context,
                        fontSize: 16,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(l('Symbol') + ':', style: _txtTitleStyle),
                ),
                Expanded(
                  flex: 4,
                  child: Text(contractInfo.symbol,
                      style: s(
                        context,
                        fontSize: 16,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(l('Decimals') + ':', style: _txtTitleStyle),
                ),
                Expanded(
                  flex: 4,
                  child: Text('${contractInfo.decimals}',
                      style: s(
                        context,
                        fontSize: 16,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onPressAddCustomToken() {

    if (_formKey.currentState!.validate()) {
      int decimals = 9;
      if (_addCustomTokenBloc.contractInfo != null) {
        decimals = _addCustomTokenBloc.contractInfo!.decimals > 0 ? _addCustomTokenBloc.contractInfo!.decimals : 9;
      }

      _addCustomTokenBloc.add(PressAddCustomTokenEvent(
        contractAddress: _txtContractAddressControler.text,
        decimals: decimals,
      ));
    }
  }

  // _onTapChooseNetwork() {
  //   ChooseNetworkDialog.show(context, onPressed: (NetworkType networkType) {
  //     _addCustomTokenBloc.add(OnChooseNetworkEvent(networkType: networkType));
  //   });
  // }
  _onTapBtnBack() {
    Navigator.of(context).pop(_addCustomTokenBloc.needReload);
  }

  _onTapQrcode() async {
    Barcode? barCode =
        await Navigator.pushNamed(context, Routes.scanQrCodeScreen) as Barcode;
    if (barCode.code != null) {
      _txtContractAddressControler.text = barCode.code!;
      // _addCustomTokenBloc.add(OnContractAddressEvent(contractAddress: barCode.code!));
    }
  }
}
