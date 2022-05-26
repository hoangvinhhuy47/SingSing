import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/sing/song_detail/song_detail_screen_event.dart';
import 'package:sing_app/blocs/sing/song_detail/song_detail_screen_state.dart';
import 'package:sing_app/data/models/mic_model.dart';
import 'package:sing_app/data/models/song_model.dart';

import '../../../data/repository/song_repository.dart';

class SongDetailScreenBloc
    extends Bloc<SongDetailScreenEvent, SongDetailScreenState> {
  final BaseSongRepository songRepository;
  SongModel songModel;

  MicModel? micModel = MicModel(
      id: '123456789', durability: '20/20', luck: "10", quality: 'Bronze');

  SongDetailScreenBloc({required this.songRepository, required this.songModel})
      : super(SongDetailScreenInitialState()) {
    on<SongDetailScreenStartedEvent>((event, emit) async {
      add(SongDetailScreenGetSongDetailEvent());
    });

    on<SongDetailScreenGetSongDetailEvent>(_mapGetSongDetailToState);
  }

  Future<void> _mapGetSongDetailToState(
      SongDetailScreenGetSongDetailEvent event,
      Emitter<SongDetailScreenState> emit) async {
    final res = await songRepository.getSongDetail(songId: songModel.songId);
    if (res.success && res.data != null) {
      songModel = res.data!;
    }
    songModel.lyric =
        '''Anh xin được dùng bài nhạc này gửi những người yêu cũ, rằng là\n\n
Nếu bây giờ em đang yên vui cùng người yêu mới\n\n
Anh cầu chúc em có những thứ không thể tìm thấy được từ nơi anh\n\n
Và ngày anh nhận được thiệp đám cưới từ em nó sẽ tới nhanh\n\n
Chúc em có thật nhiều bữa sáng trên giường ngủ\n\n
Chúc em luôn chọn được cho mình một lối đi khác trên đường cũ\n\n
Chúc em có một gia đình nhỏ mang lại niềm vui cho em\n\n
Và những đứa con có đôi mắt biếc và nụ cười tươi như em, yeah\n\n
Thật lòng đó, anh cảm thấy tự hào về em\n\n
Nhìn em xem, sự thành công biết bao người thèm\n\n
Em đã thoát khỏi những con quỷ, anh vô tình san sớt\n\n
Dù anh biết em không hề trách, và em đã nói là tình nguyện mang bớt\n\n
Chúc em vui, chúc em có thật nhiều may mắn\n\n
Chúc cho tất cả những ván bài chia đến tay em đều là cây thắng\n\n
Và anh biết, những lời này đến từ anh là sự ngạc nhiên\n\n
Nhưng có người nói hạnh phúc là khi ta đổi hận thù để nhận bình yên, thế nên là\n\n\n
All my ex's hate me\n\n
And I hate them back\n\n
And it's all because of me\n\n
And it's all because of me\n\n''';

    emit(SongDetailScreenGetSongSuccessState());
    emit(SongDetailScreenInitialState());
  }
}
