import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sing_app/oauth2/oauth2_user_info.dart';

@immutable
abstract class TransactionDetailScreenState extends Equatable {
  const TransactionDetailScreenState();

  @override
  List<Object> get props => [];
}

class TransactionDetailScreenStateInitial extends TransactionDetailScreenState {}

class TransactionDetailScreenStateLoading extends TransactionDetailScreenState {}
class TransactionDetailScreenStateLoaded extends TransactionDetailScreenState {}
