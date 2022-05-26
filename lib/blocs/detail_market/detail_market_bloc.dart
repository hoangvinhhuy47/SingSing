import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/detail_market/detail_market_state.dart';

import 'detail_market_event.dart';

class DetailMarketScreenBloc
    extends Bloc<DetailMarketScreenEvent, DetailMarketScreenState> {
  DetailMarketScreenBloc() : super(DetailMarketScreenInitialState());

}
