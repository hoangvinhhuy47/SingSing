import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TransactionDetailScreenEvent extends Equatable {
  const TransactionDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class TransactionDetailScreenEventStarted extends TransactionDetailScreenEvent {}
// class TokenDetailScreenEventReload extends TransactionDetailScreenEvent{}