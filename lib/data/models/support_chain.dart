import 'package:sing_app/constants/enum.dart';
import 'package:sing_app/utils/parse_util.dart';

class SupportChain {
  int chainId = 0;
  int networkId = 0;
  String symbol = '';
  String scanUrl = '';
  String chainName = '';

  SupportChain({
    required this.chainId,
    required this.networkId,
    required this.symbol,
    required this.scanUrl,
    required this.chainName,
  });

}