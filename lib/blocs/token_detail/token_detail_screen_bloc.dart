import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/token_detail/token_detail_screen_event.dart';
import 'package:sing_app/blocs/token_detail/token_detail_screen_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/bscscan_log_transaction.dart';
import 'package:sing_app/data/models/covalent_log_transaction.dart';
import 'package:sing_app/data/repository/bscscan_repository.dart';
import 'package:sing_app/data/repository/covalent_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/utils/logger_util.dart';

import '../../application.dart';

class TokenDetailScreenBloc extends Bloc<TokenDetailScreenEvent, TokenDetailScreenState> {
  final _pageSize = 20;

  final BaseWalletRepository walletRepository;
  final BaseCovalentRepository covalentRepository;
  final BaseBscScanRepository bscScanRepository;
  final Balance token;
  final Map<String, double> priceTable;

  // List<CovalentLogTransaction> logTransactions = [];
  List<BscScanLogTransaction> logTransactions = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _page = 1;

  TokenDetailScreenBloc({
    required this.walletRepository,
    required this.covalentRepository,
    required this.bscScanRepository,
    required this.token,
    required this.priceTable,
  }) : super(TokenDetailScreenStateInitial()){
    on<TokenDetailScreenEventStarted>((event, emit) async {
      await _mapTokenDetailScreenEventStartedToState(emit);
    });
    on<TokenDetailScreenEventLoadMore>((event, emit) async {
      await _mapTokenDetailScreenEventStartedToState(emit);
    });

  }


  Future<void> _mapTokenDetailScreenEventStartedToState(Emitter<TokenDetailScreenState> emit) async {
    // logTransactions = [];
    _isLoading = true;
    emit(TokenDetailScreenStateLoading());

    // String chainId = '1';
    // if(token.secretType == secretTypeBsc) {
    //   chainId = '${AppConfig.instance.values.supportChains[secretTypeBsc]?.chainId}';
    // }
    // if(token.secretType == secretTypeEth) {
    //   chainId = '${AppConfig.instance.values.supportChains[secretTypeEth]?.chainId}';
    // }

    bool isChainOriginal  = true;
    if(token.secretType == secretTypeBsc) {
      if(token.tokenAddress?.isNotEmpty ?? false) {
        isChainOriginal = false;
      }
    }

    Map<String, dynamic> params = {};
    params['module'] = 'account';
    if(isChainOriginal) {
      params['action'] = 'txlist';
      params['startblock'] = 0;
      params['endblock'] = 99999999;
    } else {
      params['action'] = 'tokentx';
      params['contractaddress'] = token.tokenAddress;
    }
    params['address'] = App.instance.currentWallet!.address;
    params['page'] = _page;
    params['offset'] = _pageSize;
    params['sort'] = 'desc';
    params['apikey'] = bscScanApiKey;
    final response = await bscScanRepository.fetchLogTransactions(params);
    if(response.status == '1' && response.result != null) {
      logTransactions.addAll(response.result!);
      _page +=1;
      if(response.result!.length < _pageSize) {
        _hasMore = false;
      }
    }
    if(response.status == '0') {
      _hasMore = false;
    }

    LoggerUtil.info('fetchLogTransactions logTransactions length: ${logTransactions.length}');
    _isLoading = false;
    emit(TokenDetailScreenStateLoaded());
  }



}
