import 'package:sirikit_media_intents/messages.g.dart';

abstract class MediaIntentsHandler {
  List<MediaItem> resolveMediaItems(MediaSearch mediaSearch);

  void playMediaItems(List<MediaItem> mediaItems);
}
