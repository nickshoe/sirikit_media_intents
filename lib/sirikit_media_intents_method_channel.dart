import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sirikit_media_intents_platform_interface.dart';

/// An implementation of [SirikitMediaIntentsPlatform] that uses method channels.
class MethodChannelSirikitMediaIntents extends SirikitMediaIntentsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sirikit_media_intents');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
