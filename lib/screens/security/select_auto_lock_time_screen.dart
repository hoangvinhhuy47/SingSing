import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/select_auto_lock_time/select_auto_lock_time_bloc.dart';
import 'package:sing_app/blocs/select_auto_lock_time/select_auto_lock_time_event.dart';
import 'package:sing_app/blocs/select_auto_lock_time/select_auto_lock_time_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/enum.dart';
import 'package:sing_app/manager/app_lock_manager.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';


class SelectAutoLockTimeScreen extends StatefulWidget {
  const SelectAutoLockTimeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SelectAutoLockTimeScreenState createState() =>
      _SelectAutoLockTimeScreenState();
}

class _SelectAutoLockTimeScreenState extends State<SelectAutoLockTimeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late SelectAutoLockTimeBloc _selectAutoLockTimeBloc;
  // late RootBloc _rootBloc;

  @override
  void initState() {
    _selectAutoLockTimeBloc = BlocProvider.of<SelectAutoLockTimeBloc>(context);
    _selectAutoLockTimeBloc.autoLockDuration = AppLockManager.instance.autoLockDuration;
    super.initState();
  }

  @override
  void dispose() {
    _selectAutoLockTimeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: S2EAppBar(
        title: l('Auto Lock'),
        isBackNavigation: true,
      ),
      body: _buildBloc(),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<SelectAutoLockTimeBloc, SelectAutoLockTimeState>(
      listener: (ctx, state) {
        // if(state is ChangePasswordStateErrorSaving && state.message.isNotEmpty) {
        //   showSnackBarError(context: context, message: state.message);
        // }
      },
      builder: (ctx, state) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          children: [
            _buildSelectTimeBlock(),
          ],
        ));
  }

  Widget _buildSelectTimeBlock() {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtil.blockBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildSelectTimeItem(AutoLockDuration.immediate),
          _buildDivider(),
          _buildSelectTimeItem(AutoLockDuration.oneMinute),
          _buildDivider(),
          _buildSelectTimeItem(AutoLockDuration.fiveMinute),
          _buildDivider(),
          _buildSelectTimeItem(AutoLockDuration.oneHour),
          _buildDivider(),
          _buildSelectTimeItem(AutoLockDuration.fiveHour),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF394C94),
    );
  }

  Widget _buildSelectTimeItem(AutoLockDuration autoLockDuration) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _selectAutoLockTimeBloc.add(AutoLockTimeChangedEvent(autoLockDuration: autoLockDuration));
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 13, 18, 13),
        child: Row(
          children: [
            Text(autoLockDuration.title, style: s(context, fontSize: 16, color: Colors.white)),
            if(autoLockDuration == _selectAutoLockTimeBloc.autoLockDuration) const Spacer(),
            if(autoLockDuration == _selectAutoLockTimeBloc.autoLockDuration) ImageUtil.loadAssetsImage(fileName: 'ic_selected_item.svg'),
          ],
        ),
      ),
    );
  }

}
