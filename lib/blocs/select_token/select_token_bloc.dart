
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/select_token/select_token_event.dart';
import 'package:sing_app/blocs/select_token/select_token_state.dart';
import 'package:sing_app/data/models/balance.dart';

import '../../application.dart';

class SelectTokenBloc extends Bloc<SelectTokenEvent, SelectTokenState> {

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<Balance> _balances = [];
  List<Balance> get balances => _balances;

  SelectTokenBloc() : super(SelectTokenStateInitial()){
    on<SelectTokenEventStart>((event, emit) async {
      _balances = App.instance.availableBalances;
      emit(SelectTokenStateInitial());
    });
    on<OnTextSearchChangedEvent>((event, emit) async {
      await _mapOnTextSearchChangedEventToState(event, emit);
    });
    on<OnTapBtnSeachEvent>((event, emit) async {
      _isSearching = !_isSearching;
      emit(SelectTokenStateShowSearchTextField(isShowSearchTextField: _isSearching));
    });
  }

  Future<void> _mapOnTextSearchChangedEventToState(OnTextSearchChangedEvent event, Emitter<SelectTokenState> emit) async {
    // _balances = App.instance.allBalances;
    emit(SelectTokenStateInitial());

    _balances = [];
    for(Balance item in App.instance.availableBalances) {
      if(item.symbol.toLowerCase().contains(event.text.toLowerCase())) {
        _balances.add(item);
      }
    }

    emit(SelectTokenStateLoaded());
  }


}