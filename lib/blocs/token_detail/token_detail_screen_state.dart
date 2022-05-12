import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sing_app/oauth2/oauth2_user_info.dart';

@immutable
abstract class TokenDetailScreenState extends Equatable {
  const TokenDetailScreenState();

  @override
  List<Object> get props => [];
}

class TokenDetailScreenStateInitial extends TokenDetailScreenState {}
class TokenDetailScreenStateLoading extends TokenDetailScreenState {}
class TokenDetailScreenStateLoaded extends TokenDetailScreenState {}
