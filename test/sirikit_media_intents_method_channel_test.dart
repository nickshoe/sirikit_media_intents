import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirikit_media_intents/sirikit_media_intents_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSirikitMediaIntents platform = MethodChannelSirikitMediaIntents();
  const MethodChannel channel = MethodChannel('sirikit_media_intents');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
