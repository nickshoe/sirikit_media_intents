import 'package:sirikit_media_intents/messages.g.dart';

abstract class MediaIntentsHandler {
  /// > Implement this method to resolve the media items to play. If your app
  /// > isn’t completely sure of the match, return a few results with the best
  /// > match first. The system can start playing the first item and offer the
  /// > alternatives in case the user wants to play one of them instead.
  ///
  /// > &mdash; Official Apple Documentation
  Future<List<MediaItem>> resolveMediaItems(MediaSearch mediaSearch);

  // TODO: move the iOS side logic to application(_:handle:completionHandler:) on the UIApplicationDelegate object?
  Future<void> playMediaItems(List<MediaItem> mediaItems);
}
