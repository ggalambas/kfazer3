import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum ImageControllerState {
  none,
  updated,
  removed;
}

class ImageController extends ValueNotifier<ImageProvider?> {
  final bool hasInitialImage;
  var state = ImageControllerState.none;

  ImageController({String? url})
      : hasInitialImage = url != null,
        super(_imageFromUrl(url));

  Uint8List? get bytes {
    final imageProvider = value;
    return imageProvider is MemoryImage ? imageProvider.bytes : null;
  }

  void setBytes(Uint8List? bytes) {
    if (bytes != null) {
      state = ImageControllerState.updated;
    } else {
      state = hasInitialImage
          ? ImageControllerState.removed
          : ImageControllerState.none;
    }
    value = _imageFromBytes(bytes);
  }

  static NetworkImage? _imageFromUrl(String? url) =>
      url == null ? null : NetworkImage(url);
  static MemoryImage? _imageFromBytes(Uint8List? bytes) =>
      bytes == null ? null : MemoryImage(bytes);
}
