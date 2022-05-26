import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/mic_model.dart';
import '../../../../data/models/super_pass_nft_model.dart';
import 'items_tab_event.dart';
import 'items_tab_state.dart';

class ItemsTabBloc extends Bloc<ItemsTabEvent, ItemsTabState> {
  List<SuperPassNftModel> superPassList = [];
  List<MicModel> micList = [];

  ItemsTabBloc() : super(ItemsTabInitialState()) {
    on<ItemsTabStartedEvent>(_mapItemsTabStartedEventToState);
  }

  Future<void> _mapItemsTabStartedEventToState(
      ItemsTabStartedEvent event, Emitter<ItemsTabState> emit) async {
    emit(const ItemsTabLoadingState(isLoading: true));

    for (var i = 0; i < 10; i++) {
      micList.add(MicModel(id: '$i', type: 'Professional', quality: 'Bronze'));
    }
    emit(const ItemsTabLoadingState(isLoading: true));
    emit(ItemsTabInitialState());
  }
}
