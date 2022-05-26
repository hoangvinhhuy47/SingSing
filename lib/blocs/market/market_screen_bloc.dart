import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/market/market_screen_event.dart';
import 'package:sing_app/blocs/market/market_screen_state.dart';
import 'package:sing_app/data/models/market.dart';
import 'package:sing_app/utils/color_util.dart';

class MarketScreenBloc extends Bloc<MarketScreenEvent, MarketScreenState> {
  List<MarketModel> marketModel = [
    MarketModel('Silver', ColorUtil.blueGrey, '1/100', '100', 'Professtional'),
    MarketModel('Gold', ColorUtil.gold, '1/100', '100', 'Studio'),
    MarketModel('Gold', ColorUtil.gold, '1/100', '100', 'Battle'),
    MarketModel('Bronze', ColorUtil.orange, '1/100', '100', 'Solo'),
    MarketModel('Silver', ColorUtil.blueGrey, '1/100', '100', 'Solo'),
  ];

  MarketScreenBloc() : super(MarketScreenInitialState()) {
    on((event, emit) => mapGetItemMarketState);
  }
  Future mapGetItemMarketState(
      MarketScreenEvent event, Emitter<MarketScreenState> emit) async {
    // Dumb data
    // for (int i = 0; i < 10; i++) {
    //   if (i % 2 == 0) {
    //     marketModel.add(MarketModel(
    //         'Silver', ColorUtil.blueGrey, '$i/100', '$i/00', 'Studio'));
    //   } else {
    //     marketModel.add(MarketModel(
    //         'Gold Tier', ColorUtil.gold, '$i/200', '$i/00', 'Battle'));
    //   }
    // }
    emit(MarketScreenInitialState());
  }
}
