import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/verify_passcode/verify_passcode_bloc.dart';
import 'package:sing_app/blocs/verify_passcode/verify_passcode_event.dart';
import 'package:sing_app/blocs/verify_passcode/verify_passcode_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/passcode_keyboard.dart';
import 'package:sing_app/widgets/shake_widget.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';



class VerifyPasscodeScreen extends StatefulWidget {

  const VerifyPasscodeScreen({Key? key,}) : super(key: key);

  @override
  _VerifyPasscodeScreenState createState() => _VerifyPasscodeScreenState();
}

class _VerifyPasscodeScreenState extends State<VerifyPasscodeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late VerifyPasscodeBloc _verifyPasscodeBloc;
  // late RootBloc _rootBloc;
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void initState() {
    _verifyPasscodeBloc = BlocProvider.of<VerifyPasscodeBloc>(context);
    // _rootBloc = BlocProvider.of<RootBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _verifyPasscodeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: S2EAppBar(
        title: _verifyPasscodeBloc.isLogin ? l('Login') : l('Verify Passcode'),
        isBackNavigation: !_verifyPasscodeBloc.isDisableBackBtn,
      ),
      body: WillPopScope(
        onWillPop: () async {
          return !_verifyPasscodeBloc.isDisableBackBtn;
        },
        child: _buildBloc(),
      )

    );
  }

  Widget _buildBloc() {
    return BlocConsumer<VerifyPasscodeBloc, VerifyPasscodeState>(
      listener: (ctx, state) {
        if(state is VerifyPasscodeFailState) {
          shakeKey.currentState?.shake();
        }
        if(state is VerifyPasscodeSuccessState) {

          Navigator.pop(context, state.passcode);
        }
        if(state is OnLoginSuccessState) {
          Navigator.pop(context, true);
        }
      },
      // buildWhen: (ctx, state) {
      //   return true;
      // },
      builder: (ctx, state) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            const SizedBox(height: 150),
            Text(
                _verifyPasscodeBloc.isVerifyPasscode ? l('Confirm your passcode') : l('Enter your passcode'),
                style: s(context, fontSize: 16, color: Colors.white)
            ),
            const SizedBox(height: 40),
            ShakeWidget(
              key: shakeKey,
              shakeOffset: 10,
              child: _buildPasscodeRow(),
            ),
            const Spacer(),
            PasscodeKeyboard(
              onPressedKey: (keyNumber) {
                _verifyPasscodeBloc.add(OnTapKeyboardNumberEvent(number: keyNumber));
              },
            ),
          ],
        ));
  }

  Widget _buildPasscodeRow() {
    int dotCount = _verifyPasscodeBloc.isVerifyPasscode ? _verifyPasscodeBloc.verifyPasscode.length : _verifyPasscodeBloc.checkPasscode.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 44),
        for(var i = 0; i < dotCount; i++) _buildDot(),
        for(var i = dotCount; i < 6; i++) _buildDash(),
      ],
    );
  }

  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFC4C4C4)),
    );
  }

  Widget _buildDash() {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 24,
      height: 5,
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white),
    );
  }
}
