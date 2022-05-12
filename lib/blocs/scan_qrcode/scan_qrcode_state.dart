

import 'package:equatable/equatable.dart';

abstract class ScanQrCodeState extends Equatable {
  const ScanQrCodeState();

  @override
  List<Object> get props => [];
}

class ScanQrCodeStateInitial extends ScanQrCodeState {}