abstract class ItemsTabState {
  const ItemsTabState();
}

class ItemsTabInitialState extends ItemsTabState {}

class ItemsTabGetNftState extends ItemsTabState {}

class ItemsTabLoadingState extends ItemsTabState {
  final bool isLoading;

  const ItemsTabLoadingState({required this.isLoading});
}
