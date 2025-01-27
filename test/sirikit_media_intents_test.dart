import 'package:flutter_test/flutter_test.dart';
import 'package:sirikit_media_intents/sirikit_media_intents.dart';
import 'package:sirikit_media_intents/sirikit_media_intents_platform_interface.dart';
import 'package:sirikit_media_intents/sirikit_media_intents_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSirikitMediaIntentsPlatform
    with MockPlatformInterfaceMixin
    implements SirikitMediaIntentsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SirikitMediaIntentsPlatform initialPlatform = SirikitMediaIntentsPlatform.instance;

  test('$MethodChannelSirikitMediaIntents is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSirikitMediaIntents>());
  });

  test('getPlatformVersion', () async {
    SirikitMediaIntents sirikitMediaIntentsPlugin = SirikitMediaIntents();
    MockSirikitMediaIntentsPlatform fakePlatform = MockSirikitMediaIntentsPlatform();
    SirikitMediaIntentsPlatform.instance = fakePlatform;

    expect(await sirikitMediaIntentsPlugin.getPlatformVersion(), '42');
  });
}
