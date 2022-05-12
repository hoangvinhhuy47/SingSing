class TransactionHash {
  String transactionHash = '';

  TransactionHash({required this.transactionHash});

  TransactionHash.fromJson(Map<dynamic, dynamic> json) {
    transactionHash = json['transaction_hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = <String, String>{};
    data['transaction_hash'] = transactionHash;
    return data;
  }
}