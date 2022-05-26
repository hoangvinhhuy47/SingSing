import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/mic/mic_screen_event.dart';
import 'package:sing_app/blocs/mic/mic_screen_state.dart';
import 'package:sing_app/data/models/mic_model.dart';

class MicScreenBloc extends Bloc<MicScreenEvent, MicScreenState> {
  MicModel? micModel= MicModel(id: '123456789', durability: '20/20', luck: "10",quality: 'Bronze');

  MicScreenBloc() : super(MicScreenInitialState()) {
    on((event, emit) => _mapGetMicToState);
  }
  Future<void> _mapGetMicToState(
      MicScreenEvent event, Emitter<MicScreenState> emit) async {
    // //Dumb data
    // micModel = MicModel(id: '123456789', durability: '20/20', luck: "10");
  }
}
