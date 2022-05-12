import 'package:equatable/equatable.dart';

abstract class ChangeWalletNameEvent extends Equatable {
  const ChangeWalletNameEvent();

  @override
  List<Object> get props => [];
}

class ChangeWalletNameEventStart extends ChangeWalletNameEvent {}
class ChangeWalletNameEventSaving extends ChangeWalletNameEvent {
  final String name;
  const ChangeWalletNameEventSaving({
    required this.name
  });
  @override
  List<Object> get props => [name];
}