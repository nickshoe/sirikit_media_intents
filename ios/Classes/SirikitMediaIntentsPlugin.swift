import Flutter
import UIKit

public class SirikitMediaIntentsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        let channel = FlutterMethodChannel(
            name: "sirikit_media_intents",
            binaryMessenger: messenger)
        
        let instance = SirikitMediaIntentsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(
        _ call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "initialize":
            result(FlutterMethodNotImplemented)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
