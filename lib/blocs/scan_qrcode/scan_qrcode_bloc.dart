import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/scan_qrcode/scan_qrcode_event.dart';
import 'package:sing_app/blocs/scan_qrcode/scan_qrcode_state.dart';


class ScanQrCodeBloc extends Bloc<ScanQrCodeEvent, ScanQrCodeState> {

  ScanQrCodeBloc(
  ) : super(ScanQrCodeStateInitial());

}