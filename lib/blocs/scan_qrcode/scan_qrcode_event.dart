import 'package:equatable/equatable.dart';

abstract class ScanQrCodeEvent extends Equatable {
  const ScanQrCodeEvent();

  @override
  List<Object> get props => [];
}

class ScanQrCodeEventStart extends ScanQrCodeEvent {}