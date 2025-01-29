import 'package:flutter/foundation.dart';
import 'package:sirikit_media_intents/messages.g.dart';
import 'package:sirikit_media_intents/types/media_intents_handler.dart';

import 'sirikit_media_intents_platform_interface.dart';

/// An implementation of [SirikitMediaIntentsPlatform] that uses method channels.
class MethodChannelSirikitMediaIntents extends SirikitMediaIntentsPlatform {
  // ignore: unused_field
  final IOSSirikitMediaIntentsApi? _hostApi;

  MethodChannelSirikitMediaIntents({
    @visibleForTesting IOSSirikitMediaIntentsApi? api,
  }) : _hostApi = api ?? IOSSirikitMediaIntentsApi();

  @override
  Future<void> initialize(MediaIntentsHandler handler) async {
    final flutterApi = _IOSSirikitMediaIntentsFlutterApi(handler: handler);
    IOSSirikitMediaIntentsFlutterApi.setUp(flutterApi);
  }
}

class _IOSSirikitMediaIntentsFlutterApi
    implements IOSSirikitMediaIntentsFlutterApi {
  final MediaIntentsHandler handler;

  _IOSSirikitMediaIntentsFlutterApi({
    required this.handler,
  });

  @override
  Future<List<MediaItem>> resolveMediaItems(MediaSearch mediaSearch) =>
      handler.resolveMediaItems(mediaSearch);

  @override
  Future<void> playMediaItems(List<MediaItem> mediaItems) =>
      handler.playMediaItems(mediaItems);
}
