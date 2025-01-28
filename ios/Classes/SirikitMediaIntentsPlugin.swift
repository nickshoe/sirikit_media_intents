import Flutter
import Intents
import UIKit

public class SirikitMediaIntentsPlugin: NSObject, FlutterPlugin {
    public static var instance: SirikitMediaIntentsPlugin?
    public static let CHANNEL_NAME = "sirikit_media_intents"

    private var _channel: FlutterMethodChannel?
    public var channel: FlutterMethodChannel? {
        return _channel
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()

        instance = SirikitMediaIntentsPlugin()

        instance?.initChannel(binaryMessenger: messenger)

        registrar.addMethodCallDelegate(instance!, channel: instance!.channel!)
    }

    private func initChannel(binaryMessenger: FlutterBinaryMessenger) {
        if _channel == nil {
            _channel = FlutterMethodChannel(
                name: SirikitMediaIntentsPlugin.CHANNEL_NAME,
                binaryMessenger: binaryMessenger)
        }
    }

    public func handle(
        _ call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        switch call.method {
        case "getPlatformVersion":  // TODO: remove
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func resolveMediaItems(
        mediaSearch: INMediaSearch, completion: @escaping (_: Any?) -> Void
    )
        throws
    {
        guard channel != nil else {
            throw SirikitMediaIntentsPluginError.channelIsNil(
                "channel should not be nil at this point")
        }

        // TODO: pass mediaSearch relevant data to the Flutter counterpart (use pigeon)
        // send data to Flutter method and relay the response to completion handler
        _channel!.invokeMethod(
            "resolveMediaItems", arguments: [:],
            result: completion)
    }

    public func playMediaItems(
        mediaItems: [INMediaItem], completion: @escaping (_: Any?) -> Void
    ) throws {
        guard channel != nil else {
            throw SirikitMediaIntentsPluginError.channelIsNil(
                "channel should not be nil at this point")
        }

        // TODO: pass mediaItems to the Flutter counterpart (use pigeon)
        // send data to Flutter method and relay the response to completion handler
        _channel!.invokeMethod(
            "playMediaItems", arguments: [:],
            result: completion)
    }
}

enum SirikitMediaIntentsPluginError: Error {
    case channelIsNil(String)
}
