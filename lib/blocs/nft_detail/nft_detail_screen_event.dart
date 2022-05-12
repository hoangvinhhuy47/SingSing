

import 'package:equatable/equatable.dart';

abstract class NtfDetailScreenEvent extends Equatable {
  const NtfDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class NtfDetailScreenEventStarted extends NtfDetailScreenEvent {}
