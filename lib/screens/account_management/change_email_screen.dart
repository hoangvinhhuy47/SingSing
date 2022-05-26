import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/extensions/string_extension.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/loading_indicator.dart';

import '../../application.dart';
import '../../blocs/change_email/change_email_bloc.dart';
import '../../blocs/change_email/change_email_event.dart';
import '../../blocs/change_email/change_email_state.dart';

class ChangeEmailScreen extends StatefulWidget {

  const ChangeEmailScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late ChangeEmailBloc _bloc;

  final TextEditingController _emailController = TextEditingController(text: App.instance.userApp?.email ?? '');

  @override
  void initState() {
    _bloc = BlocProvider.of<ChangeEmailBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBloc(),
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
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(l('Change email')),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<ChangeEmailBloc, ChangeEmailState>(
      listener: (ctx, state) {
        if(state is ChangeEmailStateSaved) {
          showSnackBarSuccess(context: context, message: state.message.isNotEmpty ? state.message : l('Email changed successfully'));
        }
        if(state is ChangeEmailStateErrorSaving && state.message.isNotEmpty) {
          showSnackBarError(context: context, message: state.message);
        }
      },
      builder: (ctx, state) {
        final bool isLoading = (state is ChangeEmailStateLoading && state.showLoading);
        return LoadingIndicator(
          isLoading: isLoading ,
          child: _buildBody(),
        );

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(l('Email'), style: s(context, color: ColorUtil.lightGrey, fontSize: 14, fontWeight: FontWeight.w500)),
                    if(App.instance.userApp?.email.isNotEmpty ?? false)
                      Text(' (${l('Not verified')})', style: s(context, color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),

                const SizedBox(height: 5),
                _buildTextField(_emailController),
              ],
            ),
          ),
          DefaultGradientButton(
            text: l('Save').toUpperCase(),
            width: MediaQuery.of(context).size.width - 40,
            onPressed: _onSaveButtonPressed,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildTextField(TextEditingController controller) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      autocorrect: false,
      enableSuggestions: false,
      controller: controller,
      maxLength: 255,
      decoration: const InputDecoration(
        counterText: '',
        fillColor: ColorUtil.bgTextFieldColor,
        filled: true,
        contentPadding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 18.0),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: ColorUtil.bgTextFieldColor),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: ColorUtil.bgTextFieldColor)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: ColorUtil.bgTextFieldColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Color(0xFF6C34FF)),
        ),
      ),
    );
  }


  _onSaveButtonPressed() {
    if(_emailController.text.isEmpty) {
      showSnackBarError(context: context, message: l('Email cannot be empty'));
      return;
    }

    if(!_emailController.text.isValidEmail()) {
      showSnackBarError(context: context, message: l('Email is not valid'));
      return;
    }

    _bloc.add(ChangeEmailEventSaving(newEmail: _emailController.text));
  }
}
