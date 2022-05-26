import 'package:sing_app/data/models/song_model.dart';
import '../../constants/constants.dart';
import '../response/ss_response.dart';
import 'api_manager.dart';
import 'base_api.dart';

class SongApiProvider {
  final BaseAPI _baseAPI;

  SongApiProvider(this._baseAPI);

  Future<PaginatorSsResponse<SongModel>> getSongs(
      {int offset = 0,
      String keyword = '',
      int limit = Constants.defaultApiLimit}) async {
    try {
      final Map resJson = await _baseAPI
          .request(manager: ApiManager(ApiType.getSongs), queryParams: {
        'offset': offset,
        'keyword': keyword,
        'limit': limit,
      });
      final res = PaginatorSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        final List<SongModel> items = [];
        for (final itemJson in res.data ?? []) {
          final item = SongModel.fromJson(itemJson);
          items.add(item);
        }
        return PaginatorSsResponse(
            data: items, pagination: res.pagination);
      } else {
        return PaginatorSsResponse(error: res.error, success: false);
      }
    } catch (e) {
      return PaginatorSsResponse<SongModel>.withError(
          SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse<SongModel>> getSongDetail(
      {required String songId}) async {
    try {
      final Map resJson = await _baseAPI.request(
          manager:
              ApiManager(ApiType.getSongDetail, additionalPath: songId));
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        final item = SongModel.fromJson(res.data);

        return DefaultSsResponse(data: item);
      } else {
        return DefaultSsResponse(error: res.error, success: false);
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }
}
