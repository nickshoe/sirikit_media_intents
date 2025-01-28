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

    public init(application: UIApplication, plugin: SirikitMediaIntentsPlugin) {
        self.application = application
        self.plugin = plugin
    }

    public func resolveMediaItems(
        for intent: INPlayMediaIntent,
        with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) ->
            Void
    ) {
        if let mediaSearch = intent.mediaSearch {
            // TODO: is there a swift equivalent for async/await?
            plugin.resolveMediaItems(mediaSearch: mediaSearch) {
                mediaItems in

                let result = INPlayMediaMediaItemResolutionResult.successes(
                    with: mediaItems)

                completion(result)
            }

            return
        }

        // TODO: refactor
        let result = INPlayMediaMediaItemResolutionResult.unsupported()

        completion([result])
    }

    public func handle(
        intent: INPlayMediaIntent,
        completion: @escaping (INPlayMediaIntentResponse) -> Void
    ) {
        if let mediaItems = intent.mediaItems {
            plugin.playMediaItems(mediaItems: mediaItems) {
                // TODO: receive a param from the Flutter app for deciding if to put the app in foreground or not (defaults to no)
                // To put the app in foreground after handling the play request
                // if application.applicationState == .background {
                //     // .continueInApp -> The system should launch the app in the foreground to play the media.
                //     completion(INPlayMediaIntentResponse(code: .continueInApp, userActivity: nil))
                //
                //     return
                // }

                // .success -> The app is playing the media.
                completion(
                    INPlayMediaIntentResponse(
                        code: .success, userActivity: nil))
            }

            return
        }

        // TODO: refactor
        let result = INPlayMediaIntentResponse(
            code: .failure, userActivity: nil)

        completion(result)
    }

}
