import 'package:sing_app/data/data_provider/s2e_song_provider.dart';
import 'package:sing_app/data/models/song_model.dart';

import '../data_provider/base_api.dart';
import '../response/ss_response.dart';

abstract class BaseSongRepository {
  Future<PaginatorSsResponse<SongModel>> getSongs({int offset, String keyword});

  Future<DefaultSsResponse<SongModel>> getSongDetail({required String songId});
}

class SongRepository extends BaseSongRepository {
  late SongApiProvider _songApiProvider;

  SongRepository(BaseAPI baseAPI) {
    _songApiProvider = SongApiProvider(baseAPI);
  }

  @override
  Future<PaginatorSsResponse<SongModel>> getSongs(
      {int offset = 0, String keyword = ''}) {
    return _songApiProvider.getSongs(offset: offset, keyword: keyword);
  }

  @override
  Future<DefaultSsResponse<SongModel>> getSongDetail({required String songId}) {
    return _songApiProvider.getSongDetail(songId: songId);
  }
}
