#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sirikit_media_intents.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sirikit_media_intents'
  s.version          = '0.3.3'
  s.summary          = 'A plugin to implement iOS SiriKit Media Intents support in your Flutter app.'
  s.description      = <<-DESC
A plugin to implement iOS SiriKit Media Intents support in your Flutter app.
                       DESC
  s.homepage         = 'https://github.com/nickshoe'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Nicolò Scarpa' => 'nicolo.scarpa@gmail.com' }
  s.source           = { :http => 'https://github.com/nickshoe/sirikit_media_intents' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'sirikit_media_intents_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
