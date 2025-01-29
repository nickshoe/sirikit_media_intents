# sirikit_media_intents

A Flutter plugin to implement iOS SiriKit Media Intents support.

## Getting Started

> [!NOTE]
> This plugin requires several modifications to the iOS generated project.

To see the plugin in action just look at the example app, under `example` folder.

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

### Flutter app

You need to create a class that implements/extends the `MediaIntentsHandler` interface/abstract class.

The semantics of the `resolveMediaItems` and `playMediaItems` should appear pretty clear by the following example.

```dart
class ExampleMediaIntentsHandler extends MediaIntentsHandler {
  @override
  List<MediaItem> resolveMediaItems(MediaSearch mediaSearch) {
    // TODO: call backend APIs to find media items matching the search criteria

    var mediaItems = [
      MediaItem(
        identifier: '<song-1-id>',
        title: 'Cool song 1',
        type: MediaItemType.song,
        artist: 'Cool Artist 1',
      ),
      MediaItem(
        identifier: '<song-2-id>',
        title: 'Cool song 2',
        type: MediaItemType.song,
        artist: 'Cool Artist 2',
      )
    ];

    return mediaItems;
  }

  @override
  void playMediaItems(List<MediaItem> mediaItems) {
    log('Queuing ${mediaItems.length} songs');
    // TODO: call App media services for queueing media items
    
    log('Playing ${mediaItems.first.identifier} - ${mediaItems.first.title}');
    // TODO: call App media services for playing a media item
  }
}
```

In the code that initializes your app (the `main` method is a good candidate) you should add the following lines for initializing the plugin, by telling which class is going to handle the iOS Siri media intent callbacks:

```dart
void main() {
  final sirikitMediaIntentsPlugin = SirikitMediaIntents();
  final mediaIntentsHandler = ExampleMediaIntentsHandler();

  WidgetsFlutterBinding.ensureInitialized();
  
  sirikitMediaIntentsPlugin.initialize(mediaIntentsHandler);

  // ...

  runApp(MyApp());
}
```