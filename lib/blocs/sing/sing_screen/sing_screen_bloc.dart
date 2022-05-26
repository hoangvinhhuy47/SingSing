import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/sing/sing_screen/sing_screen_event.dart';
import 'package:sing_app/blocs/sing/sing_screen/sing_screen_state.dart';
import 'package:sing_app/data/models/song_model.dart';
import 'package:sing_app/data/repository/song_repository.dart';


class SingScreenBloc extends Bloc<SingScreenEvent, SingScreenState> {
  final BaseSongRepository songRepository;
  final List<SongModel> _songList = [];
  int _total = 1;
  bool _isLoading = true;

  List<SongModel> get songList => _songList;

  bool get isLoading => _isLoading;

  SingScreenBloc({required this.songRepository})
      : super(SingScreenInitialState()) {
    on<SingScreenGetSongsEvent>(_mapGetSongScreenToState);
  }

  Future _mapGetSongScreenToState(
      SingScreenGetSongsEvent event, Emitter<SingScreenState> emit) async {
    _isLoading = true;
    if (_songList.isEmpty) {
      emit(const SingScreenLoadingState(isLoading: true));
    }
    if (event.isRefresh) {
      _songList.clear();
    }
    /// call api
    final res = await songRepository.getSongs(
        offset: event.isRefresh ? 0 : _songList.length);

    if (res.success) {
      _songList.addAll(res.data!);
      _total = res.pagination!.total;
    }

    _isLoading = false;
    emit(SingScreenGetSongsSuccessState());
    emit(SingScreenInitialState());
  }

  bool isHasMore() => _songList.length < _total;
}
