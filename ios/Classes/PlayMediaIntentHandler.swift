//
//  PlayMediaIntentHandler.swift
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
        with completion: @escaping (
            [INPlayMediaMediaItemResolutionResult]
        ) -> Void
    ) {
        if let mediaSearch = intent.mediaSearch {
            // TODO: is there a swift equivalent for async/await?
            plugin.resolveMediaItems(mediaSearch: mediaSearch) {
                mediaItems in

                let result = INPlayMediaMediaItemResolutionResult.successes(
                    with: mediaItems
                )

                completion(result)
            }

            return
        }

        let result = INPlayMediaMediaItemResolutionResult.unsupported()

        completion([result])
    }

    public func handle(
        intent: INPlayMediaIntent,
        completion: @escaping (INPlayMediaIntentResponse) -> Void
    ) {
        if let mediaItems = intent.mediaItems {
            plugin.playMediaItems(mediaItems: mediaItems) {

                completion(
                    INPlayMediaIntentResponse(
                        code: .success,  // .success -> The app is playing the media.
                        userActivity: nil
                    )
                )
            }

            return
        }

        let result = INPlayMediaIntentResponse(
            code: .failure,
            userActivity: nil
        )

        completion(result)
    }

}
