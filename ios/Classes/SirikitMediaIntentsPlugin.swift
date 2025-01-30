import Flutter
import Intents
import IntentsUI
import UIKit

public class SirikitMediaIntentsPlugin:
    NSObject,
    FlutterPlugin,
    IOSSirikitMediaIntentsApi
{
    public static var instance: SirikitMediaIntentsPlugin?

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
        let flutterMediaSearch = toFlutterMediaSearch(mediaSearch: mediaSearch)

        // send data to Flutter method and relay the response to completion handler
        flutterApi.resolveMediaItems(
            mediaSearch: flutterMediaSearch
        ) { result in
            do {
                // TODO: handle flutter-side errors

                let flutterMediaItems = try result.get()
                let mediaItems = flutterMediaItems.map(self.toMediaItem)

                completion(mediaItems)
            } catch {
                completion([])  // TODO: handle and return error here
            }
        }
    }

    public func playMediaItems(
        mediaItems: [INMediaItem],
        completion: @escaping () -> Void
    ) {
        let flutterMediaItems = mediaItems.map(self.toFlutterMediaItems)

        flutterApi.playMediaItems(
            mediaItems: flutterMediaItems
        ) { result in
            // TODO: handle flutter-side errors

            completion()
        }
    }

    private func toFlutterMediaSearch(mediaSearch: INMediaSearch) -> MediaSearch
    {
        let mediaItemType = MediaItemType(
            rawValue: mediaSearch.mediaType.rawValue)

        let flutterMediaSearch = MediaSearch(
            mediaIdentifier: mediaSearch.mediaIdentifier,
            mediaType: mediaItemType!,
            mediaName: mediaSearch.mediaName,
            artistName: mediaSearch.artistName,
            albumName: mediaSearch.albumName,
            genreNames: mediaSearch.genreNames,
            moodNames: mediaSearch.moodNames
        )

        return flutterMediaSearch
    }

    private func toMediaItem(flutterMediaItem: MediaItem) -> INMediaItem {
        let type = INMediaItemType(rawValue: flutterMediaItem.type.rawValue)!

        var artwork: INImage? = nil
        if flutterMediaItem.artwork != nil {
            artwork = buildINImage(
                urlString: flutterMediaItem.artwork!.url,
                width: flutterMediaItem.artwork!.width,
                height: flutterMediaItem.artwork!.height
            )
        }

        let mediaItem: INMediaItem = INMediaItem(
            identifier: flutterMediaItem.identifier,
            title: flutterMediaItem.title,
            type: type,
            artwork: artwork,
            artist: flutterMediaItem.artist
        )

        return mediaItem
    }

    private func buildINImage(
        urlString: String?,
        width: Double?,
        height: Double?
    ) -> INImage? {
        guard let urlString = urlString else {
            return nil
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        if width != nil && height != nil {
            return INImage(
                url: url,
                width: width!,
                height: height!
            )
        }
        
        return INImage(
            url: url
        )
    }
    
    private func toFlutterMediaItems(mediaItem: INMediaItem) -> MediaItem {
        let type = MediaItemType(rawValue: mediaItem.type.rawValue)
        
        let flutterMediaItem: MediaItem = MediaItem(
            identifier: mediaItem.identifier!,
            title: mediaItem.title!,
            type: type!,
            artist: mediaItem.artist!
        )
        
        return flutterMediaItem
    }

    public static var typeName: String {
        return String(describing: self)
    }
}
