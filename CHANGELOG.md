## 0.0.1

* Basic support for `INPlayMediaIntent`:
  * `resolveMediaItems` asks for a media item id to the Flutter app and wraps it as a iOS platform media item object;
  * `handle` exposes the resolved media item id to the Flutter app for it to begin playback in background.
