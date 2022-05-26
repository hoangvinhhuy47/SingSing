import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/create_wallet_verify_mnemonic/create_wallet_verify_mnemonic_bloc.dart';
import 'package:sing_app/blocs/create_wallet_verify_mnemonic/create_wallet_verify_mnemonic_event.dart';
import 'package:sing_app/blocs/create_wallet_verify_mnemonic/create_wallet_verify_mnemonic_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/dialog/loading_dialog.dart';

class CreateWalletVerifyMnemonicScreen extends StatefulWidget {
  const CreateWalletVerifyMnemonicScreen({Key? key}) : super(key: key);

  @override
  _CreateWalletVerifyMnemonicScreen createState() => _CreateWalletVerifyMnemonicScreen();
}

class _CreateWalletVerifyMnemonicScreen extends State<CreateWalletVerifyMnemonicScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late CreateWalletVerifyMnemonicBloc _bloc;
  late final TextEditingController _phraseController;
  late final FocusNode _phraseFocus;
  final Color _formItemFocusedBorderColor = const Color(0xFF6C34FF);
  Color _phraseBorder = ColorUtil.formItemBg;

  @override
  void initState() {
    _bloc = BlocProvider.of<CreateWalletVerifyMnemonicBloc>(context);
    _phraseController = TextEditingController(text: '');
    _phraseFocus = FocusNode();
    _phraseFocus.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _phraseController.dispose();
    _phraseFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateWalletVerifyMnemonicBloc, CreateWalletVerifyMnemonicState>(
        listener: (ctx, state) {
          if(state is CreateWalletVerifyMnemonicStateSaving){
            LoadingDialog.show(context, l('Saving...'));
          }
          if(state is CreateWalletVerifyMnemonicStateSaved){
            Navigator.popUntil(context, (route) {
              return route.navigator?.canPop() != true;
            });
            App.instance.eventBus.fire(EventBusNewWalletCreatingSuccessful());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l('Create new wallet successful')),
            ));
          }
          if(state is CreateWalletVerifyMnemonicStateErrorSaving){
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
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
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () =>
            Navigator.of(context).pop(),
      ),
    );
  }

  _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
            child: Column(
              children: [
                Text(
                  l('Verify secret phrase'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: ColorUtil.white
                  ),
                ),
                const SizedBox(height: MyStyles.horizontalMargin,),
                Text(
                  l('Please re-enter your secret phrase and save theme somewhere safe.'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: ColorUtil.white,
                  ),
                ),
                const SizedBox(height: MyStyles.horizontalMargin,),
                _buildInput(),
                const SizedBox(height: MyStyles.horizontalMargin,),
              ],
            ),
          )
        ),
        _buildNextButton(),
      ],
    );
  }

  _buildInput(){
    return Form(
        key: _formKey,
        child: Container(
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
                  if (value == null || value.isEmpty) {
                    return l('This field is required');
                  }
                  if(!_bloc.isValid(value)){
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
    );
  }

  _buildNextButton() {
    return Container(
      padding: const EdgeInsets.all(MyStyles.horizontalMargin),
      width: double.infinity,
      child: DefaultGradientButton(
        width: double.infinity,
        text: l('Continue').toUpperCase(),
        onPressed: _onPressedNextButton,
      ),
    );
  }


  _onPressedNextButton(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    _bloc.add(CreateWalletVerifyMnemonicEventSaving());
  }

  void _onFocusChange() {
    setState(() {
      _phraseBorder = _phraseFocus.hasFocus ? _formItemFocusedBorderColor : ColorUtil.formItemBg;
    });
  }






}