import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/change_password/change_password_bloc.dart';
import 'package:sing_app/blocs/change_password/change_password_event.dart';
import 'package:sing_app/blocs/change_password/change_password_state.dart';
import 'package:sing_app/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:sing_app/blocs/edit_profile/edit_profile_event.dart';
import 'package:sing_app/blocs/edit_profile/edit_profile_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/admin_keycloark_user_info.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/oauth2/oauth2_user_info.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/loading_indicator.dart';
import 'package:sing_app/widgets/password_textfield.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChangePasswordScreen extends StatefulWidget {

  const ChangePasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextStyle _txtTitleStyle;
  late ChangePasswordBloc _changePasswordBloc;

  final TextEditingController _oldPasswordController = TextEditingController(text: '');
  final TextEditingController _newPasswordController = TextEditingController(text: '');
  final TextEditingController _confirmNewPasswordController = TextEditingController(text: '');

  @override
  void initState() {
    _changePasswordBloc = BlocProvider.of<ChangePasswordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _changePasswordBloc.close();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
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
      title: Text(l('Change password')),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (ctx, state) {
        // if (state is EditProfileStateLoadedUserInfo) {
        //   _adminKeycloarkUserInfo = _editProfileBloc.adminKeycloarkUserInfo;
        //   if (_adminKeycloarkUserInfo != null) {
        //     _emailController.text = _adminKeycloarkUserInfo!.email;
        //     _firstNameController.text = _adminKeycloarkUserInfo!.firstName;
        //     _lastNameController.text = _adminKeycloarkUserInfo!.lastName;
        //   }
        // }
        if(state is ChangePasswordStateSaved) {
          showSnackBarSuccess(context: context, message: state.message.isNotEmpty ? state.message : l('Password changed successfully'));
        }
        if(state is ChangePasswordStateErrorSaving && state.message.isNotEmpty) {
          showSnackBarError(context: context, message: state.message);
        }
      },
      builder: (ctx, state) {
        final bool isLoading = (state is ChangePasswordStateLoading && state.showLoading);
        return LoadingIndicator(
          isLoading: isLoading ,
          child: _buildBody(),
        );

      },
    );
  }

  Widget _buildBody() {
    _txtTitleStyle = s(context, color: ColorUtil.lightGrey, fontSize: 14, fontWeight: FontWeight.w500);


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
                Text(l('Old password'), style: _txtTitleStyle),
                const SizedBox(height: 5),
                PasswordTextField(controller: _oldPasswordController),
                const SizedBox(height: 25),
                Text(l('New password'), style: _txtTitleStyle),
                const SizedBox(height: 5),
                PasswordTextField(controller: _newPasswordController),
                const SizedBox(height: 25),
                Text(l('Confirm new password'), style: _txtTitleStyle),
                const SizedBox(height: 5),
                PasswordTextField(controller: _confirmNewPasswordController),
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

  // _buildTextField(TextEditingController controller) {
  //   return TextField(
  //     style: const TextStyle(color: Colors.white),
  //     autocorrect: false,
  //     enableSuggestions: false,
  //     controller: controller,
  //     decoration: const InputDecoration(
  //       fillColor: ColorUtil.bgTextFieldColor,
  //       filled: true,
  //       contentPadding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 18.0),
  //       disabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(8)),
  //         borderSide: BorderSide(width: 1, color: ColorUtil.bgTextFieldColor),
  //       ),
  //       border: OutlineInputBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(8)),
  //           borderSide: BorderSide(color: ColorUtil.bgTextFieldColor)),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(8)),
  //         borderSide: BorderSide(width: 1, color: ColorUtil.bgTextFieldColor),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(8)),
  //         borderSide: BorderSide(width: 1, color: Color(0xFF6C34FF)),
  //       ),
  //     ),
  //   );
  // }

  _onSaveButtonPressed() {
    if(_oldPasswordController.text.isEmpty) {
      showSnackBarError(context: context, message: l('Old password cannot be empty'));
      return;
    }

    if(_newPasswordController.text.length < 6) {
      showSnackBarError(context: context, message: l('New password must be at least 6 characters'));
      return;
    }
    if(_confirmNewPasswordController.text.isEmpty) {
      showSnackBarError(context: context, message: l('Confirm new password cannot be empty'));
      return;
    }


    if(_newPasswordController.text != _confirmNewPasswordController.text) {
      showSnackBarError(context: context, message: l('Confirm new password do not match, please retype.'));
      return;
    }

    _changePasswordBloc.add(ChangePasswordEventSaving(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text
    ));
  }
}
