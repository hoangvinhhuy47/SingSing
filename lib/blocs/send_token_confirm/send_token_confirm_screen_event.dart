import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SendTokenConfirmScreenEvent extends Equatable {
  const SendTokenConfirmScreenEvent();

  @override
  List<Object> get props => [];
}

class SendTokenConfirmScreenStarted extends SendTokenConfirmScreenEvent {}

class SendTokenConfirmScreenSending extends SendTokenConfirmScreenEvent {}