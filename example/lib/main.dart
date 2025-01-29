import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sirikit_media_intents/messages.g.dart';
import 'package:sirikit_media_intents/sirikit_media_intents.dart';
import 'package:sirikit_media_intents/types/media_intents_handler.dart';

void main() {
  final sirikitMediaIntentsPlugin = SirikitMediaIntents();
  final mediaIntentsHandler = ExampleMediaIntentsHandler();

  WidgetsFlutterBinding.ensureInitialized();
  sirikitMediaIntentsPlugin.initialize(mediaIntentsHandler);

  runApp(MyApp(
    mediaIntentsHandler: mediaIntentsHandler,
  ));
}

class MyApp extends StatelessWidget {
  final ExampleMediaIntentsHandler mediaIntentsHandler;

  const MyApp({super.key, required this.mediaIntentsHandler});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      color: Colors.black87,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MediaIntentsHandler',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'resolveMediaItems',
                            style: TextStyle(
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: mediaIntentsHandler.mediaSearch$,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(
                            'Ask Siri "Play something"',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        }

                        final mediaSearch = snapshot.data!;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Search by media name ',
                            ),
                            Text(
                              '"${mediaSearch.mediaName}"',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: mediaIntentsHandler.resolveMediaItems$,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Waiting for items to be resolved');
                        }

                        var resolvedMediaItemsWidgets = snapshot.data!
                            .map(
                              (mediaItem) => Text(
                                '${mediaItem.identifier} - ${mediaItem.title}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                            .toList();

                        return Column(
                          children: [
                            Text('Resolved media items'),
                            ...resolvedMediaItemsWidgets
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      color: Colors.black87,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MediaIntentsHandler',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'playMediaItems',
                            style: TextStyle(
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: mediaIntentsHandler.queuedMediaItems$,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Waiting for items to be queued');
                        }

                        final mediaItems = snapshot.data!;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total items queued: ',
                            ),
                            Text(
                              '${mediaItems.length}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: mediaIntentsHandler.currentlyPlayingMediaItem$,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Waiting for an item to be played');
                        }

                        final mediaItem = snapshot.data!;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Playing ',
                            ),
                            Text(
                              '${mediaItem.identifier} - ${mediaItem.title}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExampleMediaIntentsHandler implements MediaIntentsHandler {
  final _mediaSearchSubject = StreamController<MediaSearch>();
  Stream<MediaSearch> get mediaSearch$ => _mediaSearchSubject.stream;

  final _resolvedMediaItemsSubject = StreamController<List<MediaItem>>();
  Stream<List<MediaItem>> get resolveMediaItems$ =>
      _resolvedMediaItemsSubject.stream;

  final _currentlyPlayingMediaItemSubject = StreamController<MediaItem>();
  Stream<MediaItem> get currentlyPlayingMediaItem$ =>
      _currentlyPlayingMediaItemSubject.stream;

  final _queuedMediaItemsSubject = StreamController<List<MediaItem>>();
  Stream<List<MediaItem>> get queuedMediaItems$ =>
      _queuedMediaItemsSubject.stream;

  @override
  Future<List<MediaItem>> resolveMediaItems(MediaSearch mediaSearch) async {
    _mediaSearchSubject.add(mediaSearch);

    // TODO: call backend APIs to find media items matching the search criteria
    var mediaItems = [
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
    _resolvedMediaItemsSubject.add(mediaItems);

    return mediaItems;
  }

  @override
  Future<void> playMediaItems(List<MediaItem> mediaItems) async {
    log('Queuing ${mediaItems.length} songs');
    // TODO: call App media services for queueing media items
    _queuedMediaItemsSubject.add(mediaItems);

    log('Playing ${mediaItems.first.identifier} - ${mediaItems.first.title}');
    // TODO: call App media services for playing a media item
    _currentlyPlayingMediaItemSubject.add(mediaItems.first);
  }
}
