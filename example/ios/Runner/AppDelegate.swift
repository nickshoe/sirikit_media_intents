import Flutter
import Intents
import UIKit
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
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: flutterEngine)

        guard flutterEngine.hasPlugin(SirikitMediaIntentsPlugin.typeName) else {
            preconditionFailure("Plugin has not been registered")
        }
        guard let pluginInstance = SirikitMediaIntentsPlugin.instance else {
            preconditionFailure("Plugin instance has not been created")
        }

        _playMediaIntentHandler = PlayMediaIntentHandler(
            application: application,
            plugin: pluginInstance
        )

        return super.application(
            application, didFinishLaunchingWithOptions: launchOptions
        )
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
