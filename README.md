# sirikit_media_intents

A Flutter plugin to implement iOS SiriKit Media Intents support.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### iOS project

#### AppDelegate.swift

Replace (or, edit) the `AppDelegate.swift` file with the following content:

```swift
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
```

#### SceneDelegate.swift

This plugin adopts the in-app intent handling strategy (availble on iOS 14.0+), so no app extensions are created; on the other hand, the iOS app must **opt-in to scenes** and **enable support for multiple scenes** (read [this](https://developer.apple.com/documentation/sirikit/dispatching-intents-to-handlers#Provide-a-handler-in-your-app)). Please, read the `Info.plist` section in the guide to complete the setup process for supporting multiple scenes.

Create the `SceneDelegate.swift` (which will serve as the main scene delegate) with the following content:

```swift
import UIKit
import sirikit_media_intents

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private var _flutterMethodChannel: FlutterMethodChannel?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("unable to obtain AppDelegate")
        }
        
        let viewController = FlutterViewController(
            engine: appDelegate.flutterEngine,
            nibName: nil,
            bundle: nil
        )
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
```

## Add Siri capablity

Add the "Siri" capability to the iOS app.
In Xcode: "Runner" target > "Signing & Capabilities" > "+ Capability" (top right button in the tab list) > Search for "Siri" and add it.

This will make the `Runner.entitlements` file look like the following example:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.developer.siri</key>
	<true/>
</dict>
</plist>
```

## Info.plist

Add the `INPlayMediaIntent` intent to the supported intents of your app.
In Xcode: "Runner" target > "General" > Scroll to the "Supported Intents" section > Click the "+" button and specify `INPlayMediaIntent` in the "Class Name" column.
Then opt-in the media categories supported by your app (e.g. "Music", "General").

The aforementioned steps should have added the following entries to the `Info.plist` file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- ... -->

    <key>INIntentsSupported</key>
	<array>
		<string>INPlayMediaIntent</string>
	</array>
	<key>INSupportedMediaCategories</key>
	<array>
        <!-- These entries depend of which categories you've opted-in in the Xcode UI -->
		<string>INMediaCategoryGeneral</string>
		<string>INMediaCategoryMusic</string>
	</array>
	
    <!-- ... -->
</dict>
</plist>
```

As mentioned above, this plugin requires the iOS app to support multiple scenes; for this reason, you must add the `UIApplicationSceneManifest` entry to the `Info.plist` file:

```xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- ... -->

	<key>UIApplicationSceneManifest</key>
	<dict>
		<key>UIApplicationSupportsMultipleScenes</key>
		<true/>
		<key>UISceneConfigurations</key>
		<dict>
			<key>UIWindowSceneSessionRoleApplication</key>
			<array>
				<dict>
					<key>UISceneConfigurationName</key>
					<string>Default Configuration</string>
					<key>UISceneDelegateClassName</key>
					<string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
					<key>UISceneStoryboardFile</key>
					<string>Main</string>
				</dict>
			</array>
		</dict>
	</dict>

    <!-- ... -->
</dict>
</plist>
```

After doing that, you should be able to find the "Application Scene Manifest" entry in the "Custom iOS Target Properties" in Xcode.
