import 'dart:io';
import 'dart:typed_data';

import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:sing_app/data/models/media.dart';

class FilePickerModel {
  Asset? photoAsset;
  File? videoFile;
  Uint8List? videoThumb;
  MediaModel? mediaExist;

  FilePickerModel({this.videoFile, this.photoAsset,this.videoThumb,this.mediaExist});
}
