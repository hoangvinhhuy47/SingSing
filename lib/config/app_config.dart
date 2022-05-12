import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/support_chain.dart';
import 'package:sing_app/utils/extensions/string_extension.dart';
import 'package:sing_app/utils/logger_util.dart';

enum Flavor {
  staging,
  production,
}

const String appProductionPackageName = 'net.singsing.app';
const String tokenIconHost = 'https://media.singsing.network/tokens/';
const encryptionKey = '1uGX19pSBdrnSiF7jaIXqjQjPEsDCJ9CnXwlMSkEAY8=';
const String appConfigStorageKey = 'app_config';

extension FlavorExtension on Flavor {
  FlavorValues getValues() {
    switch (this) {
      case Flavor.staging:
        return FlavorValues(
          enableLog: true,
          apiUrl: 'https://api-dev.singid.me',
          authUrl: 'https://sso-dev.singid.me',
          authClientId: 'SingSingDev',
          authBaseUrl: 'https://dev-app.singsing.net',
          authRedirectSchema: 'singsing',
          singNftApiUrl: 'https://api-dev.singnft.io',
          mediaUrl: 'https://media-dev.singid.me',
          bscScanUrl: 'https://api-testnet.bscscan.com/api',
          sraSingSingUrl: 'https://sra-dev.singsing.net',
          ssoSecretKey: '6d14e771-7a3a-47f1-90bc-3c7a109fb784',
          supportChains: {
            secretTypeEth: SupportChain(
              chainId: 4,
              networkId: 4,
              symbol: 'ETH',
              scanUrl: 'https://ropsten.etherscan.io/',
              chainName: 'eth testnet',
            ),
            secretTypeBsc: SupportChain(
              chainId: 97,
              networkId: 97,
              symbol: 'BNB',
              scanUrl: 'https://testnet.bscscan.com/',
              chainName: 'bsc testnet',
            ),
          },
          rpcUrls: [
            'https://data-seed-prebsc-1-s1.binance.org:8545/',
            'https://data-seed-prebsc-2-s2.binance.org:8545/',
          ],
          singSingContractAddress: '0xEc3b10C74Fa75576874151872F3D002134E48B37',
          singApiUrl: 'https://mobile-dev.singsing.net',
          nftEnable: true,
        );
      default:
        return FlavorValues(
          enableLog: false,
          apiUrl: 'https://api.singid.me',
          authUrl: 'https://sso.singid.me',
          authClientId: 'SingSing',
          authBaseUrl: 'https://app.singsing.net',
          authRedirectSchema: 'singsing',
          singNftApiUrl: 'https://api.singnft.io',
          mediaUrl: 'https://media.singid.me',
          bscScanUrl: 'https://api.bscscan.com/api',
          sraSingSingUrl: 'https://sra-dev.singsing.net',
          ssoSecretKey: 'dede5550-a138-4f2c-8b12-aee3a89992b9',
          supportChains: {
            secretTypeEth: SupportChain(
              chainId: 1,
              networkId: 1,
              symbol: 'ETH',
              scanUrl: 'https://etherscan.io/',
              chainName: 'eth',
            ),
            secretTypeBsc: SupportChain(
              chainId: 56,
              networkId: 56,
              symbol: 'BNB',
              scanUrl: 'https://bscscan.com/',
              chainName: 'bsc',
            ),
          },
          rpcUrls: [
            'https://bsc-dataseed.binance.org/',
            'https://bsc-dataseed1.defibit.io/',
          ],
          singSingContractAddress: '0xEc3b10C74Fa75576874151872F3D002134E48B37',
          singApiUrl: 'https://mobile.singsing.net',
          nftEnable: true,
        );
    }
  }
}

class FlavorValues {
  final String apiUrl;
  String authUrl;
  final String authClientId;
  final String authBaseUrl;
  final String singNftApiUrl;
  String covalentApiUrl = 'https://api.covalenthq.com/v1';
  String moralisUrl = 'https://deep-index.moralis.io/api/v2';
  final String sraSingSingUrl;
  final String bscScanUrl;
  final String authRedirectSchema;
  final String mediaUrl;
  final Map<String, SupportChain> supportChains;
  final bool enableLog;
  final String ssoSecretKey;
  List<String> rpcUrls = [];
  String singSingContractAddress = '';
  final String singApiUrl;
  bool nftEnable = true;

  FlavorValues({
    required this.apiUrl,
    required this.authUrl,
    required this.authClientId,
    required this.authBaseUrl,
    required this.singNftApiUrl,
    required this.bscScanUrl,
    required this.mediaUrl,
    required this.sraSingSingUrl,
    required this.authRedirectSchema,
    required this.supportChains,
    required this.enableLog,
    required this.ssoSecretKey,
    required this.rpcUrls,
    required this.singSingContractAddress,
    required this.singApiUrl,
    required this.nftEnable,
  });

  void merge(Map<String, dynamic> json) {
    if(json.containsKey('singsing_contract_address')){
      try{
        singSingContractAddress = json['singsing_contract_address'];
      }catch(_){}
    }
    if(json.containsKey('moralis_url')){
      try{
        moralisUrl = json['moralis_url'];
      }catch(_){}
    }
    if(json.containsKey('covalent_api_url')) {
      try{
        covalentApiUrl = json['covalent_api_url'];
      }catch(_){}
    }
    if(json.containsKey('rpc_urls')){
      try{
        List<dynamic> jsonRpcUrls = json.containsKey('rpc_urls') ? json['rpc_urls'] : [];
        rpcUrls = [];
        for(dynamic url in jsonRpcUrls) {
          rpcUrls.add(url);
        }
      }catch(_){}
    }
    if(json.containsKey('nft_enable')){
      try{
        nftEnable = json['nft_enable'];
      }catch(_){}
    }
    if(json.containsKey('auth_url')) {
      try{
        authUrl = json['auth_url'];
      }catch(_){}
    }
  }
}

class AppConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;

  static AppConfig? _instance;

  factory AppConfig(Flavor flavor, String name) {
    return _instance ??= AppConfig._internal(
      flavor,
      name,
      flavor.getValues(),
    );
  }

  AppConfig._internal(
    this.flavor,
    this.name,
    this.values,
  );

  static AppConfig get instance {
    return _instance!;
  }

  static bool isProduction() => _instance!.flavor == Flavor.production;

  static bool isStaging() => _instance!.flavor == Flavor.staging;

  bool isSingSingContract(String contract) {
    return contract.equalsIgnoreCase(_instance!.flavor.getValues().singSingContractAddress);
  }
}
