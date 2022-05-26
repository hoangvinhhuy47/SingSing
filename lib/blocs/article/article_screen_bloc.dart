import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/article/article_screen_event.dart';
import 'package:sing_app/blocs/article/article_screen_state.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/article.dart';
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/data/response/ss_response.dart';

class ArticleScreenBloc extends Bloc<ArticleScreenEvent, ArticleScreenState> {
  final BaseSsRepository ssRepository;
  final ArticleType articleType;

  ArticleModel? articleModel;

  ArticleScreenBloc({required this.ssRepository, required this.articleType})
      : super(ArticleScreenInitialState()) {
    on<ArticleScreenGetArticleEvent>((event, emit) async {
      await _mapGetArticleEventToState(event, emit);
    });
  }

  Future _mapGetArticleEventToState(ArticleScreenGetArticleEvent event,
      Emitter<ArticleScreenState> emit) async {
    emit(ArticleScreenInitialState());
    emit(const ArticleScreenLoadingState(isLoading: true));

    DefaultSsResponse<ArticleModel> res =
        await ssRepository.getArticle(type: event.articleType);
    if (res.success) {
      articleModel = res.data;
      emit(const ArticleScreenSuccessState(isSuccess: true));
    } else {
      emit(ArticleScreenSuccessState(isSuccess: false,message: res.error?.message));
    }
    emit(const ArticleScreenLoadingState(isLoading: false));
    emit(ArticleScreenInitialState());
  }
}
