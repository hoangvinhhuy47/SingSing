import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/import_wallet/import_wallet_bloc.dart';
import 'package:sing_app/blocs/import_wallet/import_wallet_event.dart';
import 'package:sing_app/blocs/import_wallet/import_wallet_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/token_util.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/dialog/loading_dialog.dart';

import '../routes.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({Key? key}) : super(key: key);

  @override
  _ImportWalletScreen createState() => _ImportWalletScreen();
}

class _ImportWalletScreen extends State<ImportWalletScreen> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late final ImportWalletBloc _bloc;
  late final TextEditingController _nameController;
  late final TextEditingController _phraseController;
  late final TextEditingController _privateKeyController;
  late final FocusNode _phraseFocus;
  late final FocusNode _privateKeyFocus;
  late TabController _tabController;
  final Color _formItemFocusedBorderColor = const Color(0xFF6C34FF);
  Color _phraseBorder = ColorUtil.formItemBg;
  Color _privateKeyBorder = ColorUtil.formItemBg;

  @override
  void initState() {
    _bloc = BlocProvider.of<ImportWalletBloc>(context);
    _nameController = TextEditingController(text: l('My Wallet') + ' ' + _bloc.chain.name);
    _phraseController = TextEditingController(text: '');
    _privateKeyController = TextEditingController(text: '');
    _tabController = TabController(
      length: 2,
      initialIndex: _bloc.selectedTabIndex,
      vsync: this,
    );
    _tabController.addListener(_onTabChangedListener);
    _phraseFocus = FocusNode();
    _phraseFocus.addListener(_onFocusChange);
    _privateKeyFocus = FocusNode();
    _privateKeyFocus.addListener(_onFocusChange);

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _nameController.dispose();
    _phraseController.dispose();
    _privateKeyController.dispose();
    _phraseFocus.dispose();
    _privateKeyFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImportWalletBloc, ImportWalletState>(
        listener: (ctx, state) {
          if(state is ImportWalletStateSaving){
            LoadingDialog.show(context, l('Saving...'));
          }
          if(state is ImportWalletStateSaved){
            var count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 4;
            });
            App.instance.eventBus.fire(EventBusNewWalletCreatingSuccessful());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l('Import new wallet successful')),
            ));
          }
          if(state is ImportWalletStateErrorSaving){
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
          if(state is ImportWalletStateStarted){
            _nameController.text = l('My Wallet') + ' ' + _bloc.chain.name + ' ${_bloc.walletCount + 1}';
          }
        },
        builder: (ctx, state) {
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
        onPressed: () =>
            Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: ImageUtil.loadAssetsImage(
              fileName: 'ic_scan.svg',
              width: 20,
              height: 20,
              color: ColorUtil.white),
          tooltip: l('Scan'),
          onPressed: _scanSmartChain,
        ),
      ],
      title: Text(l('Import') + ' ' + _bloc.chain.name),
    );
  }

  Future _scanSmartChain() async {
    final result = await Navigator.pushNamed(context, Routes.sendTokenScanQrCodeScreen);
    if (result != null && result is String) {
      if (_tabController.index == 0) {
        _phraseController.text = result;
      } else {
        _privateKeyController.text = result;
      }
    }
  }

  _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l('Name'), style: MyStyles.of(context).tooltipText()),
                  const SizedBox(height: MyStyles.horizontalMargin / 2),
                  _buildNameTextField(),
                  const SizedBox(height: MyStyles.horizontalMargin),
                  Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorUtil.formItemBg,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: _buildTabBar(),
                    ),
                  ),
                  const SizedBox(height: MyStyles.horizontalMargin / 2),
                  IndexedStack(
                    index: _bloc.selectedTabIndex,
                    children: _getTabBarWidgetItem(),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildImportWalletButton(),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.articleScreen, arguments: {
              ArticleScreenArgs.articleType: ArticleType.whatIsSecretPhrase
            });
          },
          child: Text(
            l('What is Secret Phrase') + '?',
          ),
        ),
      ],
    );
  }

  _buildNameTextField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white, fontSize: 16),
      autocorrect: false,
      enableSuggestions: false,
      controller: _nameController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l('This field is required');
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorUtil.formItemBg,
        errorStyle: const TextStyle(color: ColorUtil.formErrorText),
        contentPadding: const EdgeInsets.only(top: 18, bottom: 18, left: 18.0),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: ColorUtil.formItemBg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: _formItemFocusedBorderColor),
        ),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorUtil.formItemBg)),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Material(
              child: Ink(
                color: ColorUtil.formItemBg,
                child: InkWell(
                    child: const Icon(Icons.cancel_outlined, color: ColorUtil.lightGrey, ),
                    onTap: () {_nameController.clear();}
                ),
              ),
            ),
          ),
        ),
        ),

    );
  }

  Widget _buildTabBar() {
    return TabBar(
      unselectedLabelColor: Colors.white,
      indicatorColor: Colors.transparent,
      indicator: BoxDecoration(
        color: const Color(0xFF5F667E),
        borderRadius: BorderRadius.circular(50),
      ),
      controller: _tabController,
      tabs: [
        Tab(
          height: 30,
          child: Text(
            l('Secret phrase'),
          ),
        ),
        Tab(
          height: 30,
          child: Text(
            l('Private key'),
          ),
        ),
      ],
    );
  }

  List<Widget> _getTabBarWidgetItem() {
    return [
      _buildPhraseTab(),
      _buildPrivateKeyTab(),
    ];
  }

  _buildPhraseTab(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorUtil.formItemBg,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1, color: _phraseBorder),
          ),
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white),
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.multiline,
                controller: _phraseController,
                focusNode: _phraseFocus,
                maxLines: 5,
                validator: (value) {
                  if(_tabController.index != 0){
                    return null;
                  }
                  if (value == null || value.isEmpty) {
                    return l('This field is required');
                  }
                  if(!TokenUtil.validateMnemonic(value)){
                    return l('Invalid secret phrase');
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorStyle: const TextStyle(color: ColorUtil.formErrorText),
                    contentPadding: const EdgeInsets.only(top: 14.0, bottom: 14.0, left: 18.0, right: 18.0),
                    hintText: l('Secret phrase'),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(onPressed: (){
                    _phraseController.text = '';
                  }, child: Text(l('Clear'))),
                  TextButton(onPressed: () async{
                    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
                    if(cdata != null && cdata.text != null && cdata.text!.isNotEmpty){
                      _phraseController.text = cdata.text!;
                    }
                  }, child: Text(l('Paste'))),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Text(l('Typically 12 (sometimes 24) words separated by single spaces'),
            style: MyStyles.of(context).hintText().copyWith(fontSize: 12)
        ),
      ],
    );
  }

  _buildPrivateKeyTab(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorUtil.formItemBg,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1, color: _privateKeyBorder),
          ),
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white),
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.multiline,
                controller: _privateKeyController,
                focusNode: _privateKeyFocus,
                maxLines: 5,
                validator: (value) {
                  if(_tabController.index != 1){
                    return null;
                  }
                  if (value == null || value.isEmpty) {
                    return l('This field is required');
                  }
                  if(value.length != 64){
                    return l('Private key has to be 64 characters long');
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorStyle: const TextStyle(color: ColorUtil.formErrorText),
                    contentPadding: const EdgeInsets.only(top: 14.0, bottom: 14.0, left: 18.0, right: 18.0),
                    hintText: l('Private key')
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(onPressed: (){
                    _privateKeyController.text = '';
                  }, child: Text(l('Clear'))),
                  TextButton(onPressed: () async{
                    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
                    if(cdata != null && cdata.text != null && cdata.text!.isNotEmpty){
                      _privateKeyController.text = cdata.text!;
                    }
                  }, child: Text(l('Paste'))),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Text(l('Typically 64 alphanumeric characters'),
            style: MyStyles.of(context).hintText().copyWith(fontSize: 12)
        ),
      ],
    );
  }

  _buildImportWalletButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(MyStyles.horizontalMargin,
          MyStyles.horizontalMargin, MyStyles.horizontalMargin, 0),
      child: DefaultGradientButton(
        width: double.infinity,
        text: l('Import'),
        onPressed: _onPressedImportWalletButton,
      ),
    );
  }

  void _onTabChangedListener() {
    if (_tabController.indexIsChanging) {
      _bloc.add(ImportWalletEventTabBarPressed(_tabController.index));
      if (_tabController.index == 0) {
        _phraseFocus.requestFocus();
      } else if (_tabController.index == 1) {
        _privateKeyFocus.requestFocus();
      }
    }
  }

  _onPressedImportWalletButton(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    final String data = _tabController.index == 0 ? _phraseController.text : _privateKeyController.text;
    final name = _nameController.text;
    _bloc.add(ImportWalletEventSaving(name, data));
  }

  void _onFocusChange() {
    setState(() {
      _phraseBorder = _phraseFocus.hasFocus ? _formItemFocusedBorderColor : ColorUtil.formItemBg;
      _privateKeyBorder = _privateKeyFocus.hasFocus ? _formItemFocusedBorderColor : ColorUtil.formItemBg;
    });
  }
}