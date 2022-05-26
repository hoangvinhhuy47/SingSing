abstract class SongDetailScreenState{
  const SongDetailScreenState();
}

class SongDetailScreenInitialState extends SongDetailScreenState{}
class SongDetailScreenLoadingState extends SongDetailScreenState{
  final bool isLoading;

  const SongDetailScreenLoadingState({required this.isLoading});
}
class SongDetailScreenGetSongSuccessState extends SongDetailScreenState{}

