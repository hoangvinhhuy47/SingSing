abstract class MicScreenState {
  const MicScreenState();

}

class MicScreenInitialState extends MicScreenState {}

class MicScreenGetEquipmentSuccessState extends MicScreenState {}

class MicScreenChangetoWalletState extends MicScreenState {
  final int index;

  MicScreenChangetoWalletState(this.index);
}
