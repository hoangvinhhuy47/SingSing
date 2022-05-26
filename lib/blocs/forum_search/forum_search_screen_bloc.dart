import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/forum_search/forum_search_screen_event.dart.dart';
import 'package:sing_app/blocs/forum_search/forum_search_screen_state.dart';
import 'package:sing_app/data/models/forum.dart';
import 'package:sing_app/data/repository/forum_repository.dart';

class ForumSearchScreenBloc
    extends Bloc<ForumSearchScreenEvent, ForumSearchScreenState> {
  final BaseForumRepository forumRepository;

  List<Forum> _forums = [];
  int _total = 0;

  bool _isLoading = false;

  List<Forum> get forums => _forums;

  int get total => _total;

  bool get isLoading => _isLoading;

  ForumSearchScreenBloc({
    required List<Forum> initialForums,
    required this.forumRepository,
    required int initialTotal,
  }) : super(ForumSearchScreenInitialState()) {
    on<ForumSearchScreenInitialEvent>((event, emit) async {
      _forums = initialForums.toList();
      _total = initialTotal;
      emit(ForumSearchScreenInitialState());
    });

    on<ForumSearchScreenSearchEvent>((event, emit) async {
      await (_mapForumSearchScreenEventToState(event, emit));
    });
  }

  Future _mapForumSearchScreenEventToState(ForumSearchScreenSearchEvent event,
      Emitter<ForumSearchScreenState> emit) async {
    _isLoading = true;
    emit(ForumSearchScreenLoadingState());
    final res = await forumRepository.getForums(
        offset: event.isSearch ? 0 : _forums.length, keyword: event.keyword);

    if (res.success) {
      if (event.isSearch) {
        _forums = res.data!;
      } else {
        _forums.addAll(res.data!);
      }

      _total = res.pagination!.total;
    }
    _isLoading = false;
    emit(ForumSearchScreenLoadDataSuccessState());
    emit(ForumSearchScreenInitialState());
  }
}
