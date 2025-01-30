import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/messages.g.dart',
  swiftOut: 'ios/Classes/messages.g.swift',
))
class MediaSearch {
  final String? mediaIdentifier;
  final MediaItemType mediaType;
  final String? mediaName;
  final String? artistName;
  final String? albumName;
  final List<String>? genreNames;
  final List<String>? moodNames;

  const MediaSearch({
    required this.mediaIdentifier,
    required this.mediaType,
    required this.mediaName,
    required this.artistName,
    required this.albumName,
    required this.genreNames,
    required this.moodNames,
  });
}

class MediaItem {
  final String identifier;
  final String title;
  final MediaItemType type;
  final String artist;
  final MediaItemImage? artwork;

  const MediaItem({
    required this.identifier,
    required this.title,
    required this.type,
    required this.artist,
    this.artwork,
  });
}

class MediaItemImage {
  final String url;
  final double width;
  final double height;

  MediaItemImage({
    required this.url,
    required this.width,
    required this.height,
  });
}

enum MediaItemType {
  unknown,
  song,
  album,
  artist,
  genre,
  playlist,
  podcastShow,
  podcastEpisode,
  podcastPlaylist,
  musicStation,
  audioBook,
  movie,
  tvShow,
  tvShowEpisode,
  musicVideo,
  podcastStation,
  radioStation,
  station,
  music,
  algorithmicRadioStation,
  news;
}

@FlutterApi()
abstract class IOSSirikitMediaIntentsFlutterApi {
  @async
  List<MediaItem> resolveMediaItems(MediaSearch mediaSearch);

  @async
  void playMediaItems(List<MediaItem> mediaItems);
}

@HostApi()
abstract class IOSSirikitMediaIntentsApi {}
