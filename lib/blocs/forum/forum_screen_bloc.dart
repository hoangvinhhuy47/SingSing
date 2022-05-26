import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/data/repository/forum_repository.dart';
import '../../data/models/forum.dart';
import '../forum/forum_screen_state.dart';
import 'forum_screen_event.dart';

class ForumScreenBloc extends Bloc<ForumScreenEvent, ForumScreenState> {
  List<Forum> forums = [];
  bool _isLoading = false;

  int _total = 0;

  int get total => _total;

  bool get isLoading => _isLoading;

  final BaseForumRepository forumRepository;

  ForumScreenBloc({required this.forumRepository})
      : super(ForumScreenInitialState()) {
    on<GetForumEvent>((event, emit) async {
      if (total == 0) {
        emit(const ForumScreenLoadingState(isLoading: true));
      }
      await _mapGetForumEventToState(emit, event);
    });
  }

  Future _mapGetForumEventToState(
      Emitter<ForumScreenState> emit, GetForumEvent event) async {
    _isLoading = true;
    if (forums.isEmpty) {
      emit(const ForumScreenLoadingState(isLoading: false));
    }

    final res = await forumRepository.getForums(
        offset: event.isRefresh ? 0 : forums.length);

    if (res.success) {
      if (event.isRefresh) {
        forums = res.data!;
      } else {
        forums.addAll(res.data!);
      }
      _total = res.pagination!.total;
    }
    _isLoading = false;
    emit(const ForumScreenLoadDataSuccessState());
    emit(ForumsState(forums: forums));
  }
}
