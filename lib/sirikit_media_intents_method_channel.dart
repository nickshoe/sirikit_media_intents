import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sirikit_media_intents/types/media_intents_handler.dart';

import 'sirikit_media_intents_platform_interface.dart';

/// An implementation of [SirikitMediaIntentsPlatform] that uses method channels.
class MethodChannelSirikitMediaIntents extends SirikitMediaIntentsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sirikit_media_intents');

  // TODO: remove
  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initialize(MediaIntentsHandler handler) async {
    methodChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'resolveMediaItemsId':
          var query = call.arguments as String;
          var mediaItemId = handler.resolveMediaItemsId(query);

          // TODO: handle media item not resolved (with PlatformException?)

          return mediaItemId;
        case 'playMediaItemById':
          var mediaItemId = call.arguments as String;
          handler.playMediaItemById(mediaItemId);

          // TODO: handle play exception (with PlatformException?)

          return null;
        default:
          throw PlatformException(
            code: 'unimplemented',
            message: 'Method not implemented: ${call.method}',
          );
      }
    });
  }
}
