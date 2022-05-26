// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) => ArticleModel(
      intro: json['intro'] as String?,
      title: json['title'] as String?,
      thumb: json['thumb'] as String?,
      content: json['content'] as String?,
      articleId: json['article_id'] as String?,
    );

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'intro': instance.intro,
      'title': instance.title,
      'thumb': instance.thumb,
      'content': instance.content,
      'article_id': instance.articleId,
    };
