class NftAttribute {
  String traitType = '';
  dynamic value = ''; // String or int or double ...

  NftAttribute({required this.traitType, required this.value});

  NftAttribute.fromJson(Map<String, dynamic> json) {
    traitType = json['trait_type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = <String, String>{};
    data['trait_type'] = traitType;
    data['value'] = value;
    return data;
  }
}