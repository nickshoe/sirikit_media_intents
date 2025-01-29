import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sirikit_media_intents/messages.g.dart';
import 'package:sirikit_media_intents/sirikit_media_intents_method_channel.dart';
import 'package:sirikit_media_intents/sirikit_media_intents_platform_interface.dart';
import 'package:sirikit_media_intents/types/media_intents_handler.dart';

class MockSirikitMediaIntentsPlatform
    with MockPlatformInterfaceMixin
    implements SirikitMediaIntentsPlatform {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final SirikitMediaIntentsPlatform initialPlatform =
      SirikitMediaIntentsPlatform.instance;

  test('Can be extended', () {
    SirikitMediaIntentsPlatform.instance =
        ExtendedSirikitMediaIntentsPlatform();
  });

  test('$MethodChannelSirikitMediaIntents is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSirikitMediaIntents>());
  });

  test(
      'Default implementation of initialize() should throw unimplemented error',
      () {
    // Arrange
    final ExtendedSirikitMediaIntentsPlatform platform =
        ExtendedSirikitMediaIntentsPlatform();

    // Act & Assert
    expect(
      () => platform.initialize(ExtendedMediaIntentsHandler()),
      throwsUnimplementedError,
    );
  });
}

class ExtendedSirikitMediaIntentsPlatform extends SirikitMediaIntentsPlatform {}

class ExtendedMediaIntentsHandler implements MediaIntentsHandler {
  @override
  Future<void> playMediaItems(List<MediaItem> mediaItems) {
    // TODO: implement playMediaItems
    throw UnimplementedError();
  }

  @override
  Future<List<MediaItem>> resolveMediaItems(MediaSearch mediaSearch) {
    // TODO: implement resolveMediaItems
    throw UnimplementedError();
  }
}
