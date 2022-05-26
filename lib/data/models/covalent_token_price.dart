class CovalentTokenPrice {
  int? contractDecimals;
  String? contractName;
  String? contractTickerSymbol;
  String? contractAddress;
  String? logoUrl;
  double? quoteRate;
  int? rank;

  CovalentTokenPrice(
      {this.contractDecimals,
        this.contractName,
        this.contractTickerSymbol,
        this.contractAddress,
        this.logoUrl,
        this.quoteRate,
        this.rank});

  CovalentTokenPrice.fromJson(Map<String, dynamic> json) {
    contractDecimals = json['contract_decimals'];
    contractName = json['contract_name'];
    contractTickerSymbol = json['contract_ticker_symbol'];
    contractAddress = json['contract_address'];
    logoUrl = json['logo_url'];
    quoteRate = json['quote_rate'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['contract_decimals'] = contractDecimals;
    data['contract_name'] = contractName;
    data['contract_ticker_symbol'] = contractTickerSymbol;
    data['contract_address'] = contractAddress;
    data['logo_url'] = logoUrl;
    data['quote_rate'] = quoteRate;
    data['rank'] = rank;
    return data;
  }
}