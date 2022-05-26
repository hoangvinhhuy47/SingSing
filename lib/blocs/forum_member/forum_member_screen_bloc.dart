import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/data/repository/forum_repository.dart';

import '../../data/models/forum.dart';
import 'forum_member_screen_event.dart';
import 'forum_member_screen_state.dart';

class ForumMemberScreenBloc
    extends Bloc<ForumMemberScreenEvent, ForumMemberScreenState> {
  final Forum forum;
  List<UserProfile> forumMembers;

  List<UserProfile> forumMembersSearching = [];
  int _total = 0;
  int _totalSearch = 0;

  bool _isLoading = false;

  int get total => _total;

  int get totalSearch => _totalSearch;

  bool get isLoading => _isLoading;

  final BaseForumRepository forumRepository;

  ForumMemberScreenBloc(
      {required this.forum,
      required this.forumMembers,
      required this.forumRepository})
      : super(ForumMemberScreenInitialState()) {
    on<ForumMemberScreenInitialEvent>((event, emit) async {
      forumMembersSearching = forumMembers;
      _totalSearch = 0;
    });
    on<ForumMemberScreenGetMemberEvent>((event, emit) async {
      await _mapGetMemberEventToState(event, emit);
    });
  }

  Future _mapGetMemberEventToState(ForumMemberScreenGetMemberEvent event,
      Emitter<ForumMemberScreenState> emit) async {
    _isLoading = true;
    emit(ForumMemberScreenLoadMoreState());

    final res = await forumRepository.getForumDetailMembers(
        forumId: forum.groupId,
        offset: event.isRefresh
            ? 0
            : event.isSearch
                ? forumMembersSearching.length
                : forumMembers.length,
        keyword: event.keyword.trim());

    if (res.success) {
      final resData = res.data!;
      if (event.isRefresh) {
        if (event.isSearch) {
          forumMembersSearching = resData;
        } else {
          forumMembers = resData;
        }
      } else {
        if (event.isSearch) {
          forumMembersSearching.addAll(resData);
        } else {
          forumMembers.addAll(resData);
        }
      }

      final totalRes = res.pagination!.total;
      if (event.isSearch) {
        _totalSearch = totalRes;
      } else {
        _total = totalRes;
      }
    }
    _isLoading = false;
    emit(ForumMemberScreenLoadDataSuccessState());
    emit(ForumMemberScreenMemberState());
  }
}
