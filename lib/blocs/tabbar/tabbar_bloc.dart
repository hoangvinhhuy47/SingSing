import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/tabbar/tabbar_event.dart';
import 'package:sing_app/blocs/tabbar/tabbar_state.dart';
import 'package:sing_app/utils/logger_util.dart';

class TabBarBloc extends Bloc<TabbarEvent, TabbarState> {
  TabBarBloc() : super(InitialTabbarState()){
    on<TabbarPressed>((event, emit) async {
      emit(TabbarChanged(event.index));
    });
  }
}
