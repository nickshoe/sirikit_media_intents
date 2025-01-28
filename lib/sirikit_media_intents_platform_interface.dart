import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sirikit_media_intents/types/media_intents_handler.dart';

import 'sirikit_media_intents_method_channel.dart';

abstract class SirikitMediaIntentsPlatform extends PlatformInterface {
  /// Constructs a SirikitMediaIntentsPlatform.
  SirikitMediaIntentsPlatform() : super(token: _token);

  static final Object _token = Object();

  static SirikitMediaIntentsPlatform _instance =
      MethodChannelSirikitMediaIntents();

  /// The default instance of [SirikitMediaIntentsPlatform] to use.
  ///
  /// Defaults to [MethodChannelSirikitMediaIntents].
  static SirikitMediaIntentsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SirikitMediaIntentsPlatform] when
  /// they register themselves.
  static set instance(SirikitMediaIntentsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes this plugin.
  ///
  /// Call this once before any further interaction with the plugin.
  Future<void> initialize(MediaIntentsHandler handler) async {
    throw UnimplementedError('initialize() has not been implemented.');
  }
}
