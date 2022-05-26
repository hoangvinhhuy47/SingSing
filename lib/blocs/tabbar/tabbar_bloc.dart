import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sing_app/blocs/tabbar/tabbar_event.dart';
import 'package:sing_app/blocs/tabbar/tabbar_state.dart';

class TabBarBloc extends Bloc<TabbarEvent, TabbarState> {
  final firebaseAnalytics = FirebaseAnalytics.instance;

  TabBarBloc() : super(InitialTabbarState()) {
    on<TabbarPressed>((event, emit) async {
      emit(TabbarChanged(event.index));
      switch (event.index) {
        case 0:
          firebaseAnalytics.logEvent(
              name: 'tabBarClickEvent', parameters: {'tab': 'Song Tab'});
          break;
        case 1:
          firebaseAnalytics.logEvent(
              name: 'tabBarClickEvent', parameters: {'tab': 'Mic Tab'});
          break;
        case 2:
          firebaseAnalytics.logEvent(
              name: 'tabBarClickEvent', parameters: {'tab': 'Wallet Tab'});
          break;
        case 3:
          firebaseAnalytics.logEvent(
              name: 'tabBarClickEvent', parameters: {'tab': 'Market Tab'});
          break;
      }
    });
  }
}
