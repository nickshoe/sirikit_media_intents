//
//  PlayMediaIntentHandler.swift
//  Pods
//
//  Created by Nicolò Scarpa on 28/01/25.
//
import Foundation
import Intents
import SwiftUI

public class PlayMediaIntentHandler: NSObject, INPlayMediaIntentHandling {
    let application: UIApplication
    let plugin: SirikitMediaIntentsPlugin

    init(application: UIApplication, plugin: SirikitMediaIntentsPlugin) {
        self.application = application
        self.plugin = plugin
    }

    public func resolveMediaItems(
        for intent: INPlayMediaIntent,
        with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) ->
            Void
    ) {
        var pluginResult = plugin.resolveMediaItems()

        var result = INPlayMediaMediaItemResolutionResult.unsupported()

        if let mediaSearch = intent.mediaSearch {
            // TODO: forward the intent.mediaSearch object to Flutter and wait for the response (or use a callback)

            // TODO: unmarshall Flutter's app returned media items or error
            let mediaItem = INMediaItem(
                identifier: "<track_id>",
                title: "<track_title>",
                type: INMediaItemType.song,
                artwork: nil,
                artist: "<track_artists>"
            )

            // TODO: build the result object based on Flutter's returned data
            result = INPlayMediaMediaItemResolutionResult.success(
                with: mediaItem)
        }

        completion([result])
    }

    public func handle(
        intent: INPlayMediaIntent,
        completion: @escaping (INPlayMediaIntentResponse) -> Void
    ) {

        // TODO: handle the play request

        // To put the app in foreground after handling the play request
        // if application.applicationState == .background {
        //     // .continueInApp -> The system should launch the app in the foreground to play the media.
        //     completion(INPlayMediaIntentResponse(code: .continueInApp, userActivity: nil))
        //
        //     return
        // }

        // .success -> The app is playing the media.
        completion(INPlayMediaIntentResponse(code: .success, userActivity: nil))
    }

}
