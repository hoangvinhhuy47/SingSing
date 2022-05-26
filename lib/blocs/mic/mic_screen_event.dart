abstract class MicScreenEvent{}

class MicScreenGetMicEquipmentEvent extends MicScreenEvent {
  final bool isRefresh;

  MicScreenGetMicEquipmentEvent({this.isRefresh = false});

}

