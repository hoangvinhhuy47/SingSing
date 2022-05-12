import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_nft_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_nft_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/moralis_nft.dart';
import 'package:sing_app/data/models/nft_data.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/moralis_repository.dart';
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/utils/logger_util.dart';

class WalletDetailNftBloc
    extends Bloc<WalletDetailNftEvent, WalletDetailNftState> {
  final BaseWalletRepository walletRepository;
  final Wallet wallet;
  // final BaseSingNftRepository singNftRepository;
  // final BaseCovalentRepository covalentRepository;
  final BaseMoralisRepository moralisRepository;
  final BaseSsRepository ssRepository;

  List<MoralisNft> listNfts = [];
  bool _dataLoaded = false;

  WalletDetailNftBloc({
    required this.walletRepository,
    required this.wallet,
    // required this.singNftRepository,
    required this.ssRepository,
    required this.moralisRepository,
  }) : super(WalletDetailNftStateLoading()) {
    on<WalletDetailNftEventStart>((event, emit) async {
      await _mapWalletDetailNftEventStartToState(emit);
    });
    on<WalletDetailNftEventReload>((event, emit) async {
      await _mapWalletDetailNftEventReloadToState(emit);
    });
    on<WalletDetailNftEventTokenPriceUpdate>((event, emit) async {
      await _mapWalletDetailNftEventTokenPriceUpdateToState(emit);
    });
  }

  Future<void> _mapWalletDetailNftEventStartToState(
      Emitter<WalletDetailNftState> emit) async {
    emit(WalletDetailNftStateLoading());
    if (_dataLoaded) {
      emit(const WalletDetailNftStateLoaded(''));
      return;
    }

    listNfts.clear();
    String chainId = '56';
    String chainName = 'bsc';
    if (wallet.secretType == secretTypeBsc) {
      chainId =
          '${AppConfig.instance.values.supportChains[secretTypeBsc]?.chainId}';
      chainName =
          '${AppConfig.instance.values.supportChains[secretTypeBsc]?.chainName}';
    }
    if (wallet.secretType == secretTypeEth) {
      chainId =
          '${AppConfig.instance.values.supportChains[secretTypeEth]?.chainId}';
      chainName =
          '${AppConfig.instance.values.supportChains[secretTypeEth]?.chainName}';
    }
    Map<String, dynamic> params = {};
    params['format'] = 'decimal';
    params['chain'] = chainName;

    final response =
        await moralisRepository.fetchNFts(chainId, wallet.address, params);
    if (!response.isError) {
      _dataLoaded = true;
      if (response.result?.isNotEmpty ?? false) {
        listNfts = response.result!;
      }
    } else {
      _dataLoaded = false;
    }

    emit(const WalletDetailNftStateLoaded(''));

    // TODO hungpd load null metadata
    List<MoralisNft> listNullMetadata = [];
    List<MoralisNft> listHasMetadata = [];
    for(MoralisNft nft in listNfts) {
      if(nft.externalData == null) {
        listNullMetadata.add(nft);
      } else {
        listHasMetadata.add(nft);
      }
    }
    if(listNullMetadata.isNotEmpty) {
      for(MoralisNft nftNullMetadata in listNullMetadata) {
        if(nftNullMetadata.tokenId != null && nftNullMetadata.tokenAddress != null) {
          final response = await ssRepository.fetchNftMetadata(chainId, nftNullMetadata.tokenAddress!, nftNullMetadata.tokenId!);
          if(response.success) {
            if(response.data != null) {
              for(MoralisNft nft in listNfts) {
                if(nftNullMetadata.tokenId == nft.tokenId) {
                  LoggerUtil.info('Loaded nft metadata: ${nft.tokenId}');
                  nft.externalData = response.data!;
                  emit(WalletDetailNftStateLoaded(nftNullMetadata.tokenId!));
                  break;
                }
              }
            }
          }
        }
      }
    }

    if(listHasMetadata.isNotEmpty) {
      for(MoralisNft nftHasMetadata in listHasMetadata) {
        if(nftHasMetadata.tokenId != null && nftHasMetadata.tokenAddress != null) {
          final response = await ssRepository.fetchNftMetadata(chainId, nftHasMetadata.tokenAddress!, nftHasMetadata.tokenId!);
          if(response.success) {
            if(response.data != null) {
              for(MoralisNft nft in listNfts) {
                if(nftHasMetadata.tokenId == nft.tokenId) {
                  LoggerUtil.info('Loaded nft metadata: ${nft.tokenId}');
                  nft.externalData = response.data!;
                  emit(WalletDetailNftStateLoaded(nftHasMetadata.tokenId!));
                  break;
                }
              }
            }
          }
        }
      }
    }

    // List<MoralisNft> listNullMetadata = [];
    // String listNftsLoadMetadata = '';
    //
    // String smartContract = listNfts.first?.tokenAddress ?? '';
    // int count = 0; // load 10 nft metadata each api
    // for (MoralisNft nft in listNfts) {
    //   // if(nft.externalData == null) {
    //   //   listNullMetadata.add(nft);
    //   // }
    //   if (listNftsLoadMetadata.isEmpty) {
    //     listNftsLoadMetadata += '${nft.tokenId}';
    //   } else {
    //     listNftsLoadMetadata += ',${nft.tokenId}';
    //   }
    //   count++;
    //   if(count >= 5) {
    //     // call api
    //     if (smartContract.isNotEmpty && listNftsLoadMetadata.isNotEmpty) {
    //       final response = await ssRepository.fetchNftsMetadata(chainId, smartContract, listNftsLoadMetadata);
    //       LoggerUtil.info('fetchNftsMetadata response: ${response.data?.length}');
    //       if (!response.isError && response.data != null) {
    //         for(NftData loadedNftData in response.data!) {
    //           for (MoralisNft nft in listNfts) {
    //             if(loadedNftData.tokenId == nft.tokenId) {
    //               if(loadedNftData.metaData != null) nft.externalData = loadedNftData.metaData;
    //               break;
    //             }
    //           }
    //         }
    //         emit(WalletDetailNftStateLoaded(listNftsLoadMetadata));
    //         // reset params
    //         count = 0;
    //         listNftsLoadMetadata = '';
    //       }
    //     }
    //   }
    // }

  }

  Future<void> _mapWalletDetailNftEventReloadToState(
      Emitter<WalletDetailNftState> emit) async {
    _dataLoaded = false;
    await _mapWalletDetailNftEventStartToState(emit);
  }

  Future<void> _mapWalletDetailNftEventTokenPriceUpdateToState(
      Emitter<WalletDetailNftState> emit) async {
    emit(WalletDetailNftStateStatePriceUpdate());
  }

  bool isDataLoaded() {
    return _dataLoaded;
  }
}
