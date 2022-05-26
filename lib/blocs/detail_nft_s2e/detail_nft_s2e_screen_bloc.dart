import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/detail_nft_s2e/detail_nft_s2e_screen_event.dart';
import 'package:sing_app/blocs/detail_nft_s2e/detail_nft_s2e_screen_state.dart';
import 'package:sing_app/data/models/mic_model.dart';

class DetailNftS2EScreenBloc
    extends Bloc<DetailNftS2EScreenEvent, DetailNftS2EScreenState> {
  final MicModel? micModel;

  // final SuperPassNftModel? superPassModel;

  DetailNftS2EScreenBloc({
    this.micModel,
    // this.superPassModel,
  }) : super(DetailNftS2EScreenInitialState()) {
    on<DetailNftS2EScreenStartedEvent>(_mapDetailNftS2EStartedEventToState);
  }

  Future<void> _mapDetailNftS2EStartedEventToState(
      DetailNftS2EScreenStartedEvent event,
      Emitter<DetailNftS2EScreenState> emit) async {
    micModel?.durability = '20/20';
    micModel?.atrophy = '20/20';
    micModel?.luck = '10';
    micModel?.energy = '10/10';
    micModel?.earningBonus = '10';
    micModel?.earningRange = '50-100';
    emit(DetailNftS2EScreenGetNftDetailDoneState());
    emit(DetailNftS2EScreenInitialState());
  }
}
