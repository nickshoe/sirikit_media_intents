import 'package:sirikit_media_intents/messages.g.dart';

abstract class MediaIntentsHandler {
  Future<List<MediaItem>> resolveMediaItems(MediaSearch mediaSearch);

  Future<void> playMediaItems(List<MediaItem> mediaItems);
}
