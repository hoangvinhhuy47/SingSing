import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TokenDetailScreenEvent extends Equatable {
  const TokenDetailScreenEvent();

  @override
  List<Object> get props => [];
}
class TokenDetailScreenEventStarted extends TokenDetailScreenEvent {

  @override
  List<Object> get props => [
  ];
}


class TokenDetailScreenEventReload extends TokenDetailScreenEvent{}

class TokenDetailScreenEventLoadMore extends TokenDetailScreenEvent{}


