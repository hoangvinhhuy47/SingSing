import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TabbarEvent extends Equatable {
  const TabbarEvent();

  @override
  List<Object> get props => [];
}

class TabbarPressed extends TabbarEvent {
  final int index;

  const TabbarPressed({required this.index});

  @override
  List<Object> get props => [index];

  @override
  String toString() {
    return 'index: $index';
  }
}
