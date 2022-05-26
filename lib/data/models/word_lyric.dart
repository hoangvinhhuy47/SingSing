

class WordLyric {
  String word = '';
  double startTime = 0;
  double endTime = 0;

  WordLyric({
    required this.word,
    required this.startTime,
    required this.endTime
  });

  // WordLyric.fromJson(Map<String, dynamic> json) {
  //   tokenId = json['token_id'];
  //   tokenUrl = json['token_url'];
  //   originalOwner = json['original_owner'];
  //   metaData = Nft.fromJson(json['external_data']);
  // }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['name'] = name;
//   data['description'] = description;
//   data['background_color'] = backgroundColor;
//   data['external_url'] = externalUrl;
//   data['image'] = image;
//   // data['token_id'] = tokenId;
//   data['attributes'] = attributes?.map((v) => v.toJson()).toList();
//   return data;
// }
}

class SentenceLyric {

  List<WordLyric> wordLyrics;

  SentenceLyric({
    required this.wordLyrics,
  });

}