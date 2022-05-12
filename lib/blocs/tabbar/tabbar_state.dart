import 'package:equatable/equatable.dart';

abstract class TabbarState extends Equatable {
  const TabbarState();

  @override
  List<Object> get props => [];
}

class InitialTabbarState extends TabbarState {}

class TabbarChanged extends TabbarState {
  final int index;

  TabbarChanged(this.index);

  @override
  List<Object> get props => [index];
}
