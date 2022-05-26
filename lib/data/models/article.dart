import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class ArticleModel {
  ArticleModel({
    this.intro,
    this.title,
    this.thumb,
    this.content,
    this.articleId,
  });

  String? intro;
  String? title;
  String? thumb;
  String? content;

  @JsonKey(name: 'article_id')
  String? articleId;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}
