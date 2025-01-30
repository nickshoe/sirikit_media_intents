import 'package:sirikit_media_intents/messages.g.dart';

abstract class MediaIntentsHandler {
  /// This method closely matches the semantic of the
  /// `resolveMediaItems(for intent:INPlayMediaIntent, with completion:)`
  /// method of the `INPlayMediaIntentHandling` protocol.
  ///
  /// > Implement this method to resolve the media items to play. If your app
  /// > isn’t completely sure of the match, return a few results with the best
  /// > match first. The system can start playing the first item and offer the
  /// > alternatives in case the user wants to play one of them instead.
  ///
  /// > &mdash; Official Apple Documentation
  Future<List<MediaItem>> resolveMediaItems(MediaSearch mediaSearch);

  /// Since the plugin adopts the in-app intent handling strategy, there are no
  /// app extensions involved and the intents are handled directly in the app.
  ///
  /// For this reason, it is safe to consider `playMediaItems` method equivalent
  /// to `application(_:handlerFor:)` method on the `UIApplicationDelegate`
  /// class of your app, even if it actually gets executed in the
  /// `handle(intent:INPlayMediaIntent, completion:)` method of the plugin's
  /// class implementing the `INPlayMediaIntentHandling` protocol.
  ///
  /// The app will be launched in background and `playMediaItems` should begin
  /// the audio playback.
  Future<void> playMediaItems(List<MediaItem> mediaItems);
}
