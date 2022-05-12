import 'package:equatable/equatable.dart';

abstract class NftDetailScreenState extends Equatable {
  const NftDetailScreenState();

  @override
  List<Object> get props => [];
}

class NftDetailScreenStateInitial extends NftDetailScreenState {}
class NftDetailScreenStateLoading extends NftDetailScreenState {}
class NftDetailScreenStateLoaded extends NftDetailScreenState {}

class NftDetailScreenPlayerStateChanged extends NftDetailScreenState {
  final bool isPlaying;
  const NftDetailScreenPlayerStateChanged({
    required this.isPlaying
  });

  @override
  List<Object> get props => [isPlaying];
}