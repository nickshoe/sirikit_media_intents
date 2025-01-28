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
            // TODO: forward the intent.mediaSearch object to Flutter and handle the response in the callback
            // TODO: is there a swift equivalent for async/await?
            do {
                try plugin.resolveMediaItems { mediaItems in
                    // TODO: build the result object based on Flutter's returned data (success or failure)
                    
                    // TODO: unmarshall Flutter's app returned media items or error
                    let mediaItem = INMediaItem(
                        identifier: "<track_id>",
                        title: "<track_title>",
                        type: INMediaItemType.song,
                        artwork: nil,
                        artist: "<track_artists>"
                    )
                    
                    let result = INPlayMediaMediaItemResolutionResult.success(
                        with: mediaItem)
                    
                    completion([result])
                }
            } catch SirikitMediaIntentsPluginError.channelIsNil(let errorMessage) {
                // TODO: refactor
                
                // TODO: return unsupported reason?
                let result = INPlayMediaMediaItemResolutionResult.unsupported()
                
                completion([result])
            } catch {
                // TODO: refactor
                let result = INPlayMediaMediaItemResolutionResult.unsupported()
                
                completion([result])
            }
        } else {
            // TODO: refactor
            let result = INPlayMediaMediaItemResolutionResult.unsupported()

            completion([result])
        }
    }

    public func handle(
        intent: INPlayMediaIntent,
        completion: @escaping (INPlayMediaIntentResponse) -> Void
    ) {
        do {
            try plugin.playMediaItems { _ in
                // TODO: receive a param from the Flutter app for deciding if to put the app in foreground or not (defaults to no)
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
        } catch {
            // TODO: handle channelIsNil error?
            let result = INPlayMediaIntentResponse(code: .failure, userActivity: nil)
            
            completion(result)
        }
    }

}
