import 'package:sirikit_media_intents/types/media_intents_handler.dart';

import 'sirikit_media_intents_platform_interface.dart';

class SirikitMediaIntents {
  const SirikitMediaIntents();

  Future<String?> getPlatformVersion() {
    return SirikitMediaIntentsPlatform.instance.getPlatformVersion();
  }

  Future<void> initialize(MediaIntentsHandler handler) async =>
      SirikitMediaIntentsPlatform.instance.initialize(handler);
}
