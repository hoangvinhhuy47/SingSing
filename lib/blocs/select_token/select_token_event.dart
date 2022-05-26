import 'package:equatable/equatable.dart';

abstract class SelectTokenEvent extends Equatable {
  const SelectTokenEvent();

  @override
  List<Object> get props => [];
}

class SelectTokenEventStart extends SelectTokenEvent {}
class SelectTokenEventReload extends SelectTokenEvent {}

class OnTapBtnSeachEvent extends SelectTokenEvent {}

class OnTextSearchChangedEvent extends SelectTokenEvent {
  final String text;
  const OnTextSearchChangedEvent({required this.text});

  @override
  List<Object> get props => [text];
}


