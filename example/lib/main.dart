import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sirikit_media_intents/messages.g.dart';
import 'package:sirikit_media_intents/sirikit_media_intents.dart';
import 'package:sirikit_media_intents/types/media_intents_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _sirikitMediaIntentsPlugin = SirikitMediaIntents();

  @override
  void initState() {
    super.initState();

    _sirikitMediaIntentsPlugin.initialize(ExampleMediaIntentsHandler());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running\n'),
        ),
      ),
    );
  }
}

class ExampleMediaIntentsHandler extends MediaIntentsHandler {
  @override
  List<MediaItem> resolveMediaItems(MediaSearch mediaSearch) {
    // TODO: call backend APIs

    return [
      MediaItem(
        identifier: '<song-1-id>',
        title: 'Cool song 1',
        type: MediaItemType.song,
        artist: 'Cool Artist 1',
      ),
      MediaItem(
        identifier: '<song-2-id>',
        title: 'Cool song 2',
        type: MediaItemType.song,
        artist: 'Cool Artist 2',
      )
    ];
  }

  @override
  void playMediaItems(List<MediaItem> mediaItems) {
    final mediaItemToPlay = mediaItems.first;
    final numOfMediaItemsToQueue = mediaItems.length - 1;

    log('Playing ${mediaItemToPlay.title} by ${mediaItemToPlay.artist}');
    log('Queuing other $numOfMediaItemsToQueue songs');

    // TODO: call App media services
  }
}
