
class NetworkGasFee {
  late double gasWei;
  late double gasPriceWei;
  late double gasFeeWei;
  late double gasFeeNative;
  late String nativeSymbol;
  late double gasFeeUsd;

  NetworkGasFee(
      {required this.gasWei,
        required this.gasPriceWei,
        required this.gasFeeWei,
        required this.gasFeeNative,
        required this.nativeSymbol,
        required this.gasFeeUsd});

  NetworkGasFee.fromJson(Map<String, dynamic> json) {
    gasWei = double.parse(json['gas_wei'].toString());
    gasPriceWei = double.parse(json['gas_price_wei'].toString());
    gasFeeWei = double.parse(json['gas_fee_wei'].toString());
    gasFeeNative = double.parse(json['gas_fee_native'].toString());
    nativeSymbol = json['native_symbol'] ?? '';
    gasFeeUsd = double.parse(json['gas_fee_usd'].toString());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['gas_wei'] = gasWei;
    data['gas_price_wei'] = gasPriceWei;
    data['gas_fee_wei'] = gasFeeWei;
    data['gas_fee_native'] = gasFeeNative;
    data['native_symbol'] = nativeSymbol;
    data['gas_fee_usd'] = gasFeeUsd;
    return data;
  }
}
