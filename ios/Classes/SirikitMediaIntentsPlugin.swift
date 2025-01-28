import Flutter
import Intents
import UIKit

public class SirikitMediaIntentsPlugin: NSObject, FlutterPlugin,
    IOSSirikitMediaIntentsApi
{
    public static var instance: SirikitMediaIntentsPlugin?
    public static let CHANNEL_NAME = "sirikit_media_intents"

    private let flutterApi: IOSSirikitMediaIntentsFlutterApi

    init(
        flutterApi: IOSSirikitMediaIntentsFlutterApi
    ) {
        self.flutterApi = flutterApi
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()

        let flutterApi = IOSSirikitMediaIntentsFlutterApi(
            binaryMessenger: messenger)

        instance = SirikitMediaIntentsPlugin(flutterApi: flutterApi)

        IOSSirikitMediaIntentsApiSetup.setUp(
            binaryMessenger: messenger, api: instance)

        registrar.addApplicationDelegate(instance!)
    }

    public func handle(
        _ call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        result(FlutterMethodNotImplemented)
    }

    public func resolveMediaItems(
        mediaSearch: INMediaSearch,
        completion: @escaping ([INMediaItem]) -> Void
    ) {
        let mediaItemType = MediaItemType(rawValue: 0)
        let flutterMediaSearch = MediaSearch(
            mediaIdentifier: mediaSearch.mediaIdentifier,
            mediaType: mediaItemType!,
            mediaName: mediaSearch.mediaName,
            artistName: mediaSearch.artistName,
            albumName: mediaSearch.albumName,
            genreNames: mediaSearch.genreNames,
            moodNames: mediaSearch.moodNames
        )

        // send data to Flutter method and relay the response to completion handler
        flutterApi.resolveMediaItems(
            mediaSearch: flutterMediaSearch
        ) { result in
            do {
                // TODO: build the result object based on Flutter's returned data (success or failure)

                // TODO: unmarshall Flutter's app returned media items or error
                
                let flutterMediaItems = try result.get()
                let mediaItems = flutterMediaItems.map { flutterMediaItem in
                    return INMediaItem(
                        identifier: flutterMediaItem.identifier,
                        title: flutterMediaItem.title,
                        type: INMediaItemType.song,  // TODO: unmarshall flutterMediaItem.type
                        artwork: nil,  // TODO: ?
                        artist: flutterMediaItem.artist
                    )
                }

                completion(mediaItems)
            } catch {
                completion([])  // TODO: handle error here
            }
        }
    }

    public func playMediaItems(
        mediaItems: [INMediaItem], completion: @escaping () -> Void
    ) {
        let flutterMediaItems = mediaItems.map { mediaItem in
            let type = MediaItemType(rawValue: mediaItem.type.rawValue)

            return MediaItem(
                identifier: mediaItem.identifier!,
                title: mediaItem.title!,
                type: type!,
                artist: mediaItem.artist!
            )
        }

        // send data to Flutter method and relay the response to completion handler
        flutterApi.playMediaItems(
            mediaItems: flutterMediaItems) { result in
                // TODO: build the result object based on Flutter's returned data (success or failure)

                // TODO: unmarshall Flutter's app returned media items or error
                
                completion()
            }
    }
}

enum SirikitMediaIntentsPluginError: Error {
    case channelIsNil(String)
}
