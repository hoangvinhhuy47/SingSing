import 'package:sing_app/utils/logger_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // LoggerUtil.info('onEvent: ${event.toString()}', tag: '${bloc.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    LoggerUtil.info('onTransition: ${transition.toString()}', tag: '${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // LoggerUtil.info('onError: ${error.toString()}', tag: '${bloc.runtimeType}');
    super.onError(bloc, error, stackTrace);
  }
}
