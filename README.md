# flutter-hello

A sample drawing app for testing pen-input with flutter.

## Installation

See the full instructions [here][flutter-install].

- Make sure Xcode is installed. Personally, I had to open it and accept some agreements.
- [Download the latest flutter beta][flutter-sdk]
- Unzip it to your home directory or someplace
- Add the bin folder to your path: `export PATH=<some-dir>/flutter/bin:$PATH`
- `brew install --HEAD libimobiledevice`
- `brew install ideviceinstaller ios-deploy cocoapods`
- `pod setup`

## Running the app (debug)

- `flutter run`

## Running the app (release)

- `flutter run --release`

## Running the app on macOS

- `open macos/MacRunner.xcodeproj`
- Click the play button

[flutter-sdk]: https://flutter.io/sdk-archive/#macos
[flutter-install]: https://flutter.io/setup-macos/
