import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sing_app/oauth2/oauth2_user_info.dart';

@immutable
abstract class WalletScreenState extends Equatable {
  const WalletScreenState();

  @override
  List<Object> get props => [];
}

class WalletScreenStateInitial extends WalletScreenState {}
class WalletScreenStateLoading extends WalletScreenState {
  final bool showLoading;

  const WalletScreenStateLoading({
    this.showLoading = true
  });

  @override
  List<Object> get props => [showLoading];
}

class WalletScreenStateUserInfoFetched extends WalletScreenState {
  final bool loggedIn;

  const WalletScreenStateUserInfoFetched({
     required this.loggedIn
  });

  @override
  List<Object> get props => [loggedIn];
}

class WalletScreenStateBalanceUpdated extends WalletScreenState {
  final String walletAddress;
  final double balance;

  const WalletScreenStateBalanceUpdated({
    required this.walletAddress,
    required this.balance
  });

  @override
  List<Object> get props => [walletAddress, balance];
}

class ChangeWalletNameSuccessfulState extends WalletScreenState {
  final String walletId;
  final String name;
  const ChangeWalletNameSuccessfulState({required this.walletId, required this.name});
  @override
  List<Object> get props => [walletId, name];
}