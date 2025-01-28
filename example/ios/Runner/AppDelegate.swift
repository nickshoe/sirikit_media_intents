import Flutter
import UIKit
import Intents
import sirikit_media_intents

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var _flutterEngine = FlutterEngine(name: "FlutterEngine")
    var flutterEngine: FlutterEngine {
        return _flutterEngine
    }

    private var _playMediaIntentHandler: PlayMediaIntentHandler?
    var playMediaIntentHandler: PlayMediaIntentHandler? {
        return _playMediaIntentHandler
    }

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        // Runs the default Dart entrypoint with a default Flutter route.
        flutterEngine.run()
        // Used to connect plugins (only if you have plugins with iOS platform code).
        GeneratedPluginRegistrant.register(with: self.flutterEngine)

        _playMediaIntentHandler = PlayMediaIntentHandler(
            application: application,
            plugin: SirikitMediaIntentsPlugin.instance! // TODO: add assertion before
        )

        return super.application(
            application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(
        _ application: UIApplication, handlerFor intent: INIntent
    ) -> Any? {
        switch intent {
        case is INPlayMediaIntent:
            return _playMediaIntentHandler
        default:
            return nil
        }
    }
}
