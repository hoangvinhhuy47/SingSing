abstract class SingScreenState{
  const SingScreenState();
}

class SingScreenInitialState extends SingScreenState{}
class SingScreenLoadingState extends SingScreenState{
  final bool isLoading;

  const SingScreenLoadingState({required this.isLoading});
}
class SingScreenGetSongsSuccessState extends SingScreenState{}