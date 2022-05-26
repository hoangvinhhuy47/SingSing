import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/change_wallet_name/change_wallet_name_bloc.dart';
import 'package:sing_app/blocs/change_wallet_name/change_wallet_name_event.dart';
import 'package:sing_app/blocs/change_wallet_name/change_wallet_name_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/dialog/loading_dialog.dart';


class ChangeWalletNameScreen extends StatefulWidget {
  // final Map<String, dynamic>? args;
  const ChangeWalletNameScreen({Key? key}) : super(key: key);

  @override
  _ChangeWalletNameScreenState createState() => _ChangeWalletNameScreenState();
}

class _ChangeWalletNameScreenState extends State<ChangeWalletNameScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextStyle _txtTitleStyle;
  late ChangeWalletNameBloc _changeWalletNameBloc;
  final TextEditingController _customNameController = TextEditingController(text: '');
  final TextEditingController _currentNameController = TextEditingController(text: '');

  @override
  void initState() {
    _changeWalletNameBloc = BlocProvider.of<ChangeWalletNameBloc>(context);
    _currentNameController.text = _changeWalletNameBloc.currentName;
    super.initState();
  }
  @override
  void dispose() {
    _changeWalletNameBloc.close();
    _customNameController.dispose();
    _currentNameController.dispose();
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
      backgroundColor: const Color(0xFF1E2336),
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(l('Edit wallet name')),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<ChangeWalletNameBloc, ChangeWalletNameState>(
      listener: (ctx, state) {
        if(state is ChangeWalletNameStateSaved){
          Navigator.pop(context);
          Navigator.pop(context, true);
        }
        if(state is ChangeWalletNameStateSaving){
          LoadingDialog.show(context, l("Saving..."));
        }
        if(state is ChangeWalletNameStateErrorSaving){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      },
      builder: (ctx, state) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    _txtTitleStyle = s(context,
        color: ColorUtil.lightGrey, fontSize: 14, fontWeight: FontWeight.w500);

    return Container(
      color: const Color(0xFF1E2336),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(l('Current name'), style: _txtTitleStyle),
                const SizedBox(height: 18),
                _buildCurrentNameTextField(),
                const SizedBox(height: 16),
                Text(l('New name'), style: _txtTitleStyle),
                const SizedBox(height: 8),
                _buildCustomNameTextField(),
              ],
            ),
          ),
          DefaultButton(
            text: l('Save').toUpperCase(),
            onPressed: onSaveButtonPressed,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildCurrentNameTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      enabled: false,
      controller: _currentNameController,
      decoration: const InputDecoration(
        contentPadding:
        EdgeInsets.only(top: 14.0, bottom: 14.0, left: 18.0),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Color(0xFF413D3D)),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF413D3D))),
      ),
    );
  }

  _buildCustomNameTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      autocorrect: false,
      enableSuggestions: false,
      controller: _customNameController,
      maxLength: 100,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 18.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Color(0xFF413D3D)),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF413D3D))),
        counterText: "",
      ),
    );
  }

  onSaveButtonPressed() async {
    _changeWalletNameBloc.add(ChangeWalletNameEventSaving(name: _customNameController.text));
  }
}
