import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application.dart';
import '../../data/repository/ss_repository.dart';
import '../../oauth2/oauth2_manager.dart';
import '../../services/connectivity_service.dart';
import 'auth_screen_event.dart';
import 'auth_screen_state.dart';

class AuthScreenBloc extends Bloc<AuthScreenEvent, AuthScreenState> {
  // final BaseSsRepository ssRepository;
  final BaseSsRepository ssRepository;

  AuthScreenBloc(
      {
    required this.ssRepository,
    // required this.articleType
    }
  ) : super(AuthScreenStateInitial()) {
    on<AuthScreenCheckInternet>((event, emit) async {
      await _mapAuthScreenCheckInternetToState(event, emit);
    });

    on<AuthScreenLoggedIn>((event, emit) async {
      await _mapLoggedInToState(event, emit);
    });
  }

  Future _mapAuthScreenCheckInternetToState(AuthScreenCheckInternet event, Emitter<AuthScreenState> emit) async {

    emit(AuthScreenStateCheckInternet());
    bool hasConnection = await _checkInternetConnection();
    if(hasConnection) {
      emit(AuthScreenStateInitial());
    } else {
      emit(AuthScreenStateNoInternet());
    }
  }

  Future _mapLoggedInToState(AuthScreenLoggedIn event, Emitter<AuthScreenState> emit) async {
    emit(const AuthScreenLoadingState(isLoading: true));

    final data = await ssRepository.getUserProfile();
    if(data.success && data.data != null){
      App.instance.userApp = data.data;
      await Oauth2Manager.instance.storeUserApp(App.instance.userApp!);
      // await _setupNotificationDevice();
      emit(AuthScreenGetUserProfileSuccess(userProfile: App.instance.userApp!));
    } else {
      emit(const AuthScreenLoadingState(isLoading: false));
    }

  }

  Future<bool> _checkInternetConnection() async {
    final ConnectivityService service = ConnectivityService();
    return service.hasConnection();
  }
}
