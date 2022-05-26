

import 'package:equatable/equatable.dart';

abstract class SelectTokenState extends Equatable {
  const SelectTokenState();

  @override
  List<Object> get props => [];
}

class SelectTokenStateInitial extends SelectTokenState {}
class SelectTokenStateLoaded extends SelectTokenState {}

class SelectTokenStateShowSearchTextField extends SelectTokenState {
  final bool isShowSearchTextField;

  const SelectTokenStateShowSearchTextField({required this.isShowSearchTextField});

  @override
  List<Object> get props => [isShowSearchTextField];
}