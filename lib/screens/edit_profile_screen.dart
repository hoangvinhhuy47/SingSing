import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:sing_app/blocs/edit_profile/edit_profile_event.dart';
import 'package:sing_app/blocs/edit_profile/edit_profile_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/admin_keycloark_user_info.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/event_bus/event_bus_event.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/oauth2/oauth2_user_info.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/extensions/string_extension.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/loading_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextStyle _txtTitleStyle;
  late EditProfileBloc _editProfileBloc;
  // Oauth2UserInfo? _oauth2UserInfo;
  UserProfile? _userProfile;

  // final TextEditingController _emailController =
  //     TextEditingController(text: '');
  final TextEditingController _firstNameController =
      TextEditingController(text: '');
  final TextEditingController _lastNameController =
      TextEditingController(text: '');

  @override
  void initState() {
    _editProfileBloc = BlocProvider.of<EditProfileBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    _editProfileBloc.close();
    // _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
      title: Text(l('Edit profile')),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (ctx, state) {
        if (state is EditProfileStateLoadedUserInfo) {
          _userProfile = _editProfileBloc.userProfile;
          if (_userProfile != null) {
            // _emailController.text = _userProfile!.email;
            _firstNameController.text = _userProfile!.firstName;
            _lastNameController.text = _userProfile!.lastName;
          }
        }
        if(state is EditProfileStateSaved) {
          showSnackBarSuccess(context: context, message: l('User information changed successfully'));
        }
        if(state is EditProfileStateErrorSaving && state.message.isNotEmpty) {
          showSnackBarError(context: context, message: state.message);
        }
      },
      builder: (ctx, state) {
        final bool isLoading = (state is EditProfileStateLoading && state.showLoading);
        return LoadingIndicator(
          isLoading: isLoading ,
          child: _buildBody(),
        );

      },
    );
  }

  Widget _buildBody() {
    _txtTitleStyle = s(context,
        color: const Color(0xFFB1BBD2), fontSize: 14, fontWeight: FontWeight.w500);
    // bool isVerifiedEmail = _userProfile?.ve ?? false;
    // String txtEmailVerified =
    //     isVerifiedEmail ? l('Verified') : l('Not verified');

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
                // Row(
                //   children: [
                //     Text(l('Email'), style: _txtTitleStyle),
                //   ],
                // ),
                // const SizedBox(height: 5),
                // _buildTextField(_emailController),
                // const SizedBox(height: 20),
                Row(
                  children: [
                    Text(l('First name'), style: _txtTitleStyle),
                    const SizedBox(width: 5),
                    Text('*', style: s(context, color: Colors.red))
                  ],
                ),
                const SizedBox(height: 5),
                _buildTextField(_firstNameController),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(l('Last name'), style: _txtTitleStyle),
                    const SizedBox(width: 5),
                    Text('*', style: s(context, color: Colors.red))
                  ],
                ),
                const SizedBox(height: 5),
                _buildTextField(_lastNameController),
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
    // if(_emailController.text.trim().isEmpty) {
    //   showSnackBarError(context: context, message: l('Email cannot be empty'));
    //   return;
    // }
    //
    // if(!_emailController.text.trim().isValidEmail()) {
    //   showSnackBarError(context: context, message: l('Email is not valid'));
    //   return;
    // }

    if(_firstNameController.text.trim().isEmpty) {
     showSnackBarError(context: context, message: l('First name cannot be empty'));
     return;
    }

    if(_lastNameController.text.trim().isEmpty) {
      showSnackBarError(context: context, message: l('Last name cannot be empty'));
      return;
    }

    _editProfileBloc.add(EditProfileEventSaving(
        // email: _emailController.text.trim(),
        firstName: _firstNameController.text,
        lastName: _lastNameController.text
    ));
  }
}
