import 'package:sing_app/constants/constants.dart';

abstract class ArticleScreenEvent{}

class ArticleScreenGetArticleEvent extends ArticleScreenEvent {
  final ArticleType articleType;

  ArticleScreenGetArticleEvent({required this.articleType});
}