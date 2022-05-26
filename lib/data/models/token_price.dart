class TokenPrice {
  String symbol = '';
  String price = '';

  TokenPrice({required this.symbol, required this.price});

  TokenPrice.fromJson(Map<dynamic, dynamic> json) {
    symbol = json['symbol'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = <String, String>{};
    data['price'] = price;
    data['symbol'] = symbol;
    return data;
  }
}