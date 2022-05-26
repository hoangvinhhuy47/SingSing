import 'dart:io';

class ImagePickerModel {
  ImagePickerModel({required this.file, required this.mimeType});

  File file;
  String mimeType;
}
