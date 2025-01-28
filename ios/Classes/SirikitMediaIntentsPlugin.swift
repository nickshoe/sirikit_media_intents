import Flutter
import UIKit

public class SirikitMediaIntentsPlugin: NSObject, FlutterPlugin {
    public static var instance: SirikitMediaIntentsPlugin?

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
                name: "sirikit_media_intents",
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

    /* TODO: implement
     * - this class should act as a proxy between
     *   the swift class implementing the INPlayMediaIntentHandling protocol
     *   and the method channel
     * - maybe this class should be used by the protocol implementing class
     */
    public func resolveMediaItems() -> Any {
        // TODO: send data to Flutter method and relay the response to completion handler
        let result = _channel?.invokeMethod(
            "resolveMediaItemsId", arguments: [:])

        return result
    }
}
