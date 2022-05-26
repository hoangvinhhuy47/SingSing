import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/preview_image_gallery/preview_image_gallery_event.dart';
import 'package:sing_app/blocs/preview_image_gallery/preview_image_gallery_state.dart';
import 'package:sing_app/data/models/media.dart';

class PreviewImageGalleryBloc
    extends Bloc<PreviewImageGalleryEvent, PreviewImageGalleryState> {
  final List<MediaModel> medias;
  final int initialIndex;
  final MediaModel? singleImage;

  PreviewImageGalleryBloc(
      {required this.medias,
      required this.initialIndex,
      this.singleImage})
      : super(PreviewImageInitialState());
}
