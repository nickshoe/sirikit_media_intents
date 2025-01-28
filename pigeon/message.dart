import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/messages.g.dart',
  swiftOut: 'ios/Classes/messages.g.swift',
))
class INMediaSearch {
  final String? mediaIdentifier;
  final INMediaItemType mediaType;
  final String? mediaName;
  final String? artistName;
  final String? albumName;
  final List<String>? genreNames;
  final List<String>? moodNames;

  const INMediaSearch({
    required this.mediaIdentifier,
    required this.mediaType,
    required this.mediaName,
    required this.artistName,
    required this.albumName,
    required this.genreNames,
    required this.moodNames,
  });
}

class INMediaItem {
  final String identifier;
  final String title;
  final INMediaItemType type;
  final INImage artwork;
  final String artist;

  const INMediaItem({
    required this.identifier,
    required this.title,
    required this.type,
    required this.artwork,
    required this.artist,
  });
}

class INImage {
  final String url;
  final double width;
  final double height;

  const INImage({
    required this.url,
    required this.width,
    required this.height,
  });
}

enum INMediaItemType {
  unknown(0),
  song(1),
  album(2),
  artist(3),
  genre(4),
  playlist(5),
  podcastShow(6),
  podcastEpisode(7),
  podcastPlaylist(8),
  musicStation(9),
  audioBook(10),
  movie(11),
  tvShow(12),
  tvShowEpisode(13),
  musicVideo(14),
  podcastStation(15),
  radioStation(16),
  station(17),
  music(18),
  algorithmicRadioStation(19),
  news(20);

  final int value;

  const INMediaItemType(this.value);
}

@FlutterApi()
abstract class IOSSirikitMediaIntentsFlutterApi {
  List<INMediaItem> resolveMediaItems(INMediaSearch mediaSearch);

  void playMediaItems(List<INMediaItem> mediaItems);
}

@HostApi()
abstract class IOSSirikitMediaIntentsApi {}
